# Project Overrides — www.huntergerlach.com

This file extends the universal defaults in `AGENT_INSTRUCTIONS.md` with project-specific context. Project rules win on conflict.

---

## Project Context

- **Type**: Personal site / portfolio / blog
- **Stack**: Jekyll static site generator, custom CSS (no framework), GitHub Pages hosting
- **Domain**: [www.huntergerlach.com](https://www.huntergerlach.com)
- **Comments**: GitHub Issues as backend — see `_includes/comments.html`
- **Contact form**: Formspree
- **Typography**: Source Sans Pro (self-hosted, SIL Open Font License)
- **Icons**: Inline SVGs (no icon font libraries)
- **Theme**: Dark mode default, light mode toggle (localStorage)

## Project Structure

```
_posts/          Blog posts (Markdown, YYYY-MM-DD-slug.md)
_layouts/        Page templates (post.html, page.html, atom.xml)
_includes/       Reusable partials (styles, scripts, comments, feed)
_data/           YAML data files (contact messages)
static/css/      Stylesheets (main.css, main.min.css, syntax.css)
static/js/       Scripts (comments.js, contact.js)
static/img/      Images
static/fonts/    Self-hosted fonts (WOFF2)
.well-known/     security.txt
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
- `layout: post` and `comments_id: auto` are Jekyll defaults (set in `_config.yml`), no need to specify them
- Front matter only needs: `title`, and optionally `tags`
- Comments are auto-created on push via the `create-comment-issues` workflow
- To disable comments on a post, set `comments_id:` (empty) in frontmatter
- No em dashes in new content

### Code & Styling
- No jQuery, Bootstrap, Pure.css, or Font Awesome
- No external CSS or JS frameworks
- Custom CSS only (static/css/main.css, minified to main.min.css)
- Fonts self-hosted (no Google Fonts CDN)
- Accessibility: WCAG AA color contrast compliance required
- SEO: Open Graph and Twitter Card meta tags on all pages
- Content-Security-Policy on all pages
- Inline SVGs for all icons

### Dependencies
- Minimize external dependencies
- No external CDN dependencies for styling or fonts
- Only external services: Google Analytics (GA4), Formspree, GitHub API (comments)

## Quality Gates

Before committing changes:

1. `bundle exec jekyll build` must succeed
2. Visually verify affected pages render correctly via local server
3. Verify accessibility (color contrast, alt attributes, semantic HTML)
4. Check CSP allows any new resource origins
5. If CSS changes, regenerate main.min.css
