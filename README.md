# www.huntergerlach.com

[![GitHub Pages](https://img.shields.io/static/v1?label=GitHub+Pages&message=enabled&color=brightgreen)](https://pages.github.com/)
[![GitHub Issues](https://img.shields.io/static/v1?label=GitHub+Issues&message=comments&color=purple)](https://github.com/HunterGerlach/www.huntergerlach.com/issues)
[![GitHub License](https://img.shields.io/github/license/HunterGerlach/www.huntergerlach.com.svg)](https://github.com/HunterGerlach/www.huntergerlach.com/blob/main/LICENSE)

Personal site built with [Jekyll](https://jekyllrb.com/), freely hosted on [GitHub Pages](https://pages.github.com/). Uses GitHub Issues as a comments backend.

## Architecture Overview

- **Jekyll** static site generator hosted on **GitHub Pages**
- **GitHub Issues** as the comment backend (see [ADR 0001](docs/adr/0001-use-github-issues-for-comments.md))
- **No CSS framework** — custom CSS with CSS Grid, Flexbox, and custom properties
- **Self-hosted fonts** (Source Sans Pro, SIL Open Font License)
- **Dark mode by default** with light mode toggle (localStorage preference)
- **Formspree** for the contact form
- **Inline SVGs** for icons (no icon font libraries)
- **Content-Security-Policy** restricting resource origins (see [ADR 0005](docs/adr/0005-add-content-security-policy.md))
- **JSON-LD** structured data for site metadata
- **Google Analytics** (GA4) for usage insights

## Project Structure

```
_posts/          Blog posts (Markdown)
_layouts/        Page templates (post, page, atom)
_includes/       Reusable partials (styles, scripts, comments, feed)
_data/           YAML data files (contact messages)
static/css/      Stylesheets (main, syntax highlighting)
static/js/       Scripts (comments, contact form)
static/img/      Images
static/fonts/    Self-hosted Source Sans Pro (WOFF2)
.agent/          Agent playbook support files
.well-known/     security.txt
.github/         CI workflows
docs/adr/        Architecture Decision Records
scripts/         Maintenance scripts
_config.yml      Jekyll configuration
```

## How Comments Work

Each blog post can optionally have a `comments_id` field in its frontmatter that maps to a GitHub Issue number in this repo. When a post has `comments_id`, `_includes/comments.html` loads `static/js/comments.js` which fetches comments from the GitHub API and renders them on the post page with HTML sanitization. Readers click through to the linked GitHub Issue to leave a new comment.

### Adding comments to a new post

Comments are enabled by default. Every new post automatically gets `comments_id: auto` via Jekyll defaults in `_config.yml`. When you push to `main`, the `create-comment-issues` workflow creates a GitHub Issue and replaces `auto` with the real issue number.

To disable comments on a specific post, set `comments_id:` (empty) in its frontmatter. To set a specific issue number manually, use `comments_id: <number>`.

## Writing a New Blog Post

1. Create a file in `_posts/` named `YYYY-MM-DD-your-title-slug.md`.
2. Add frontmatter:

   ```yaml
   ---
   title: Your Post Title
   tags:
   - topic
   - another-topic
   ---
   ```

   `layout: post` and `comments_id: auto` are inherited from defaults in `_config.yml`. No need to specify them unless overriding.

   `comments_id` defaults to `auto` via `_config.yml`. You can omit it (comments enabled), set it to a specific issue number, or leave it empty to disable comments.

3. Write content in Markdown below the frontmatter.
4. Push to `main` — GitHub Pages builds and deploys automatically.

Posts are served at `www.huntergerlach.com/<title-slug>.html` (configured via `permalink: /:title.html` in `_config.yml`).

## Build & Deployment

Pushes to `main` trigger GitHub Pages' **built-in Jekyll build** (the "pages build and deployment" action visible in the Actions tab).

### CI Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push/PR to main | Jekyll build + HTML validation (html-proofer) + WCAG 2.1 AA accessibility audit (pa11y-ci) |
| `link-check.yml` | Weekly (Monday) / manual | Check external links, auto-PR with Wayback Machine replacements |
| `create-comment-issues.yml` | Push to main (posts) | Create GitHub Issues for posts with `comments_id: auto` |

## Running Locally

1. Install Jekyll by following the [installation guide](https://jekyllrb.com/docs/installation/).
2. Clone this repository: `git clone https://github.com/HunterGerlach/www.huntergerlach.com.git`
3. Navigate to the repo: `cd www.huntergerlach.com`
4. Install dependencies: `make install`
5. Start the local server: `make serve`
6. Open `http://localhost:3000` in your browser (port configured in `_config.yml`).

### Make Targets

| Target | Command |
|--------|---------|
| `make build` | Build the Jekyll site |
| `make serve` | Start local dev server |
| `make test` | Build + validate HTML with html-proofer |
| `make check-links` | Check external URLs for broken links |
| `make a11y` | Build + run WCAG 2.1 AA accessibility audit (requires Node.js) |
| `make install` | Install Ruby dependencies |

## Contributing

PRs are welcome! If you have suggestions or changes, please submit a PR.

1. Fork this repository.
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/www.huntergerlach.com.git`
3. Create a branch: `git checkout -b my-new-branch`
4. Make your changes and commit: `git commit -am "Description of changes"`
5. Push to your fork: `git push origin my-new-branch`
6. Submit a PR from your fork to this repository.
