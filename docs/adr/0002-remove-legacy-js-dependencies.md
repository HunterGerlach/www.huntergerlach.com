# ADR 0002: Remove Legacy JavaScript Dependencies

**Date:** 2026-02-14
**Status:** Accepted

## Context

The site included jQuery, Bootstrap JS, Pure.css, and Font Awesome — all loaded from CDNs. None were actively used: jQuery was only used in the comments script (replaceable with `fetch`), Bootstrap JS had no consumers (no dropdowns, modals, or collapse), Pure.css was overridden entirely by custom CSS, and Font Awesome was replaced by inline SVGs in prior work.

Each unused dependency added page weight, external requests, and attack surface for no benefit.

## Decision

Remove all four dependencies. Replace the jQuery-based comments fetch with vanilla `fetch()` API. Keep Bootstrap CSS (the only dependency with active consumers — grid, navbar, utilities).

## Consequences

- **Faster page loads** — eliminated 4 external HTTP requests and ~200KB of unused assets.
- **Reduced attack surface** — fewer third-party scripts to trust.
- **Simpler dependency tree** — only Bootstrap CSS and Google Fonts remain as external resources.
- **No functionality lost** — all features work identically with vanilla JS.
