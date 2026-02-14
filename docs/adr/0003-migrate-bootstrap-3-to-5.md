# ADR 0003: Migrate Bootstrap 3 to 5

**Date:** 2026-02-14
**Status:** Accepted

## Context

Bootstrap 3.4.1 reached end-of-life and receives no security or bug fixes. The site used Bootstrap for layout (grid, navbar, panels, labels, image utilities) but no JavaScript features. The navbar has only 2 items (home + blog), so no mobile collapse/JS is needed.

Staying on Bootstrap 3 meant accumulating custom CSS overrides for features that Bootstrap 5 provides natively (CSS custom properties, modern flexbox utilities, built-in accessibility classes).

## Decision

Migrate from Bootstrap 3.4.1 to Bootstrap 5.3 (CSS only, no JS bundle). Use `navbar-expand` (always expanded) since the navbar is minimal. Replace ~60 lines of `.navbar-default` CSS overrides with ~10 lines using BS5 CSS custom properties. Rename all BS3 class names to their BS5 equivalents (panel→card, label→badge, img-circle→rounded-circle, sr-only→visually-hidden, text-muted→text-body-secondary).

## Consequences

- **Modern CSS features** — CSS custom properties, flexbox utilities, smaller bundle.
- **Net reduction of 72 lines** — mostly from eliminating verbose navbar overrides.
- **No Bootstrap JS dependency** — CSS-only migration, consistent with ADR 0002.
- **CDN version pinned with SRI hash** — integrity verified on every page load.
- **Future upgrades easier** — BS5 is actively maintained with regular patches.
