# ADR 0005: Add Content-Security-Policy

**Date:** 2026-02-14
**Status:** Accepted

## Context

The site loads resources from several external origins (Bootstrap CDN, Google Fonts, Google Analytics, GitHub API, Formspree) and renders user-generated content (GitHub Issue comments via `innerHTML`). Without a Content-Security-Policy, any XSS vulnerability could load arbitrary scripts, exfiltrate data, or deface the page.

## Decision

Add a CSP via `<meta http-equiv="Content-Security-Policy">` in the base layout. The policy restricts each resource type to known origins:

- **default-src**: `'none'` (deny by default)
- **script-src**: `'self' 'unsafe-inline'` + `googletagmanager.com` (GA requires inline)
- **style-src**: `'self' 'unsafe-inline'` + `cdn.jsdelivr.net` + `fonts.googleapis.com`
- **font-src**: `fonts.gstatic.com`
- **img-src**: `'self'` + `avatars.githubusercontent.com`
- **connect-src**: `api.github.com` + `google-analytics.com` + `googletagmanager.com`
- **form-action**: `formspree.io`
- **frame-ancestors**: `'none'`

Combined with the HTML sanitizer in comments.html (strips scripts, event handlers, javascript: URLs), this provides defense in depth against XSS.

## Consequences

- **XSS mitigation** — even if sanitization is bypassed, CSP blocks unauthorized script sources.
- **`unsafe-inline` required** — Google Analytics uses an inline script snippet. This weakens the script-src directive. A future improvement would be to use a nonce or hash.
- **New external resources require CSP updates** — adding a new CDN or API will fail silently until the CSP is updated. This is intentional friction.
- **Meta tag, not HTTP header** — GitHub Pages doesn't support custom response headers. The meta tag approach covers most directives but not all (e.g., `frame-ancestors` is only advisory in meta tags). Acceptable tradeoff for a static site.
