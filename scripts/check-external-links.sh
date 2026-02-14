#!/usr/bin/env bash
# check-external-links.sh — Find broken external links and suggest Wayback Machine replacements.
#
# Usage: ./scripts/check-external-links.sh [--fix]
#   --fix   Replace broken links with Wayback Machine URLs in source files
#
# Scans _posts/, _includes/, and root .html/.md files for external URLs,
# checks each with a HEAD request, and for any that fail:
#   1. Uses git log to find when the link was introduced
#   2. Queries the Wayback Machine API for an archived snapshot near that date
#   3. Reports the broken link with its suggested replacement
#
# Exit codes: 0 = all links OK or all fixed, 1 = broken links remain

set -eo pipefail

FIX_MODE=false
if [[ "${1:-}" == "--fix" ]]; then
  FIX_MODE=true
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
TIMEOUT=10
USER_AGENT="Mozilla/5.0 (compatible; link-checker/1.0)"
BROKEN_COUNT=0
FIXED_COUNT=0

# Collect all source files to scan
mapfile -t FILES < <(find "$REPO_ROOT" \
  \( -path "$REPO_ROOT/_posts" -o -path "$REPO_ROOT/_includes" -o -path "$REPO_ROOT/_layouts" \) -name '*.md' -o -name '*.html' \
  -not -path "$REPO_ROOT/_site/*" \
  -not -path "$REPO_ROOT/.git/*" \
  -not -path "$REPO_ROOT/vendor/*" \
  | sort -u)

# Also add root-level .md and .html files
while IFS= read -r f; do
  FILES+=("$f")
done < <(find "$REPO_ROOT" -maxdepth 1 \( -name '*.md' -o -name '*.html' \) | sort -u)

# Deduplicate
mapfile -t FILES < <(printf '%s\n' "${FILES[@]}" | sort -u)

# Extract unique external URLs from all files
declare -A URL_SOURCE
for file in "${FILES[@]}"; do
  while IFS= read -r url; do
    # Skip common false positives
    [[ "$url" =~ ^https?://(localhost|127\.0\.0\.1|example\.com) ]] && continue
    # Skip Jekyll/Liquid template URLs
    [[ "$url" =~ \{\{ ]] && continue
    # Skip bare domains with no path (typically CSP directives, not content links)
    [[ "$url" =~ ^https?://[^/]+/?$ ]] && continue
    # Skip placeholder URLs in documentation
    [[ "$url" =~ YOUR-USERNAME|YOUR-ORG|example\.org ]] && continue
    # Store first file where URL appears
    if [[ -z "${URL_SOURCE[$url]:-}" ]]; then
      URL_SOURCE["$url"]="$file"
    fi
  done < <(grep -oEh 'https?://[^"'"'"')<> ]+' "$file" 2>/dev/null | sed 's/].*//' | sed 's/`.*//' | sed 's/[.,;:!)*]*$//' | sort -u)
done

TOTAL="${#URL_SOURCE[@]}"
echo "Checking $TOTAL unique external URLs..."
echo ""

CHECKED=0
for url in "${!URL_SOURCE[@]}"; do
  CHECKED=$((CHECKED + 1))
  printf "\r  [%d/%d] Checking..." "$CHECKED" "$TOTAL" >&2

  # HEAD request with fallback to GET
  HTTP_CODE=$(curl -sI -o /dev/null -w '%{http_code}' \
    --max-time "$TIMEOUT" -L \
    -A "$USER_AGENT" \
    "$url" 2>/dev/null || echo "000")

  # Retry with GET if HEAD returns 405 or 403
  if [[ "$HTTP_CODE" == "405" || "$HTTP_CODE" == "403" ]]; then
    HTTP_CODE=$(curl -so /dev/null -w '%{http_code}' \
      --max-time "$TIMEOUT" -L \
      -A "$USER_AGENT" \
      "$url" 2>/dev/null || echo "000")
  fi

  # Skip successful responses
  if [[ "$HTTP_CODE" =~ ^(200|301|302|303|307|308)$ ]]; then
    continue
  fi

  SOURCE_FILE="${URL_SOURCE[$url]}"
  REL_FILE="${SOURCE_FILE#$REPO_ROOT/}"
  BROKEN_COUNT=$((BROKEN_COUNT + 1))

  # Find when this URL was introduced via git log
  INTRO_DATE=$(git -C "$REPO_ROOT" log --diff-filter=A --format='%aI' -1 \
    -S "$url" -- "$REL_FILE" 2>/dev/null | head -1)

  # Fallback: use file's earliest commit date
  if [[ -z "$INTRO_DATE" ]]; then
    INTRO_DATE=$(git -C "$REPO_ROOT" log --follow --format='%aI' -- "$REL_FILE" 2>/dev/null | tail -1)
  fi

  # Format date for Wayback Machine API (YYYYMMDD)
  if [[ -n "$INTRO_DATE" ]]; then
    WB_TIMESTAMP=$(date -jf '%Y-%m-%dT%H:%M:%S%z' "$INTRO_DATE" '+%Y%m%d' 2>/dev/null \
      || date -d "$INTRO_DATE" '+%Y%m%d' 2>/dev/null \
      || echo "")
  else
    WB_TIMESTAMP=""
  fi

  # Query Wayback Machine
  ARCHIVE_URL=""
  if [[ -n "$WB_TIMESTAMP" ]]; then
    WB_RESPONSE=$(curl -s --max-time "$TIMEOUT" \
      "https://archive.org/wayback/available?url=$(printf '%s' "$url" | jq -sRr @uri)&timestamp=$WB_TIMESTAMP" 2>/dev/null || echo "{}")
    ARCHIVE_URL=$(echo "$WB_RESPONSE" | jq -r '.archived_snapshots.closest.url // empty' 2>/dev/null || echo "")
  fi

  # Report
  echo ""
  echo "BROKEN: $url"
  echo "  Status:      $HTTP_CODE"
  echo "  File:        $REL_FILE"
  if [[ -n "$INTRO_DATE" ]]; then
    echo "  Introduced:  ${INTRO_DATE%%T*}"
  fi
  if [[ -n "$ARCHIVE_URL" ]]; then
    echo "  Archive:     $ARCHIVE_URL"

    if $FIX_MODE; then
      # Escape special chars for sed
      ESCAPED_URL=$(printf '%s' "$url" | sed 's/[&/\]/\\&/g')
      ESCAPED_ARCHIVE=$(printf '%s' "$ARCHIVE_URL" | sed 's/[&/\]/\\&/g')
      sed -i.bak "s|$ESCAPED_URL|$ARCHIVE_URL|g" "$SOURCE_FILE"
      rm -f "${SOURCE_FILE}.bak"
      echo "  FIXED:       Replaced with archive URL"
      FIXED_COUNT=$((FIXED_COUNT + 1))
    fi
  else
    echo "  Archive:     (none found)"
  fi
done

printf "\r%*s\r" 40 "" >&2
echo ""
echo "---"
echo "Results: $TOTAL checked, $BROKEN_COUNT broken, $FIXED_COUNT fixed"

if [[ $BROKEN_COUNT -gt 0 && $FIXED_COUNT -lt $BROKEN_COUNT ]]; then
  exit 1
fi
exit 0
