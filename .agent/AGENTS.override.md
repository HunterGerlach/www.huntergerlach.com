# Project Overrides — www.huntergerlach.com

This file extends the universal defaults in `AGENT_INSTRUCTIONS.md` with project-specific context. Project rules win on conflict.

---

## Project Context

- **Type**: Personal blog / portfolio site
- **Stack**: Jekyll 3.9.x static site generator, Bootstrap 5.3 CSS (no JS), GitHub Pages hosting
- **Domain**: [www.huntergerlach.com](https://www.huntergerlach.com)
- **Comments**: GitHub Issues as backend — see `_includes/comments.html`
- **Contact form**: Formspree
- **Typography**: Google Fonts (Source Sans Pro)
- **Icons**: Inline SVGs (no icon font libraries)

## Project Structure

```
_posts/          Blog posts (Markdown, YYYY-MM-DD-slug.md)
_layouts/        Page templates (layout.html, post.html, page.html)
_includes/       Reusable partials (comments, header, footer, analytics, social)
static/css/      Stylesheets (main.css, syntax.css, comments.css)
static/img/      Images
_config.yml      Jekyll configuration
CNAME            Custom domain
Gemfile          Ruby dependencies
```

## Canonical Commands

| Task | Command |
|------|---------|
| Build | `bundle exec jekyll build` |
| Serve locally | `bundle exec jekyll serve` |
| Install deps | `bundle install` |

## Conventions

### Content
- Post filenames: `YYYY-MM-DD-title-slug.md`
- Posts are served at `/:title.html` (configured via `permalink` in `_config.yml`)
- Use `comments_id: auto` in new post frontmatter for automatic GitHub Issue creation
- Front matter should include: `layout`, `title`, and optionally `tags`, `comments_id`

### Code & Styling
- No jQuery, Bootstrap JS, Pure.css, or Font Awesome — these were intentionally removed
- Bootstrap 5.3 CSS only (loaded via CDN, no JS bundle)
- Accessibility: WCAG AA color contrast compliance required
- SEO: Open Graph and Twitter Card meta tags on all pages (handled in `_layouts/layout.html`)
- Inline SVGs for all icons

### Dependencies
- Minimize external dependencies — prefer CDN for CSS frameworks, inline SVGs over icon libraries
- Pin CDN versions with SRI integrity hashes

## Tool Integration Overrides

- **Beads / Gas Town**: not used in this project. Use GitHub Issues for task tracking.
- **Testing**: no automated test suite currently configured. Visual verification via `bundle exec jekyll serve`.

## Quality Gates

Before committing changes:

1. `bundle exec jekyll build` must succeed
2. Visually verify affected pages render correctly via local server
3. Check that no Bootstrap 3 class names were reintroduced
4. Verify accessibility (color contrast, alt attributes, semantic HTML)
