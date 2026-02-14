# www.huntergerlach.com

[![GitHub Pages](https://img.shields.io/static/v1?label=GitHub+Pages&message=enabled&color=brightgreen)](https://pages.github.com/)
[![GitHub Issues](https://img.shields.io/static/v1?label=GitHub+Issues&message=comments&color=purple)](https://github.com/HunterGerlach/www.huntergerlach.com/issues)
[![GitHub License](https://img.shields.io/github/license/HunterGerlach/www.huntergerlach.com.svg)](https://github.com/HunterGerlach/www.huntergerlach.com/blob/main/LICENSE)

Personal blog built with [Jekyll](https://jekyllrb.com/) and [Bootstrap](https://getbootstrap.com/), freely hosted on [GitHub Pages](https://pages.github.com/). Uses GitHub Issues as a comments backend.

## Architecture Overview

- **Jekyll** static site generator (v3.9.x) hosted on **GitHub Pages**
- **GitHub Issues** as the comment backend — no third-party comment service needed
- **Bootstrap 3** + custom CSS for styling
- **Formspree** for the contact form

## Project Structure

```
_posts/          Blog posts (Markdown)
_layouts/        Page templates (layout, post, page, home)
_includes/       Reusable partials (comments, header, footer, analytics, social)
static/css/      Stylesheets
static/js/       JavaScript
static/img/      Images
_config.yml      Jekyll configuration
CNAME            Custom domain (www.huntergerlach.com)
Gemfile          Ruby dependencies
```

## How Comments Work

Each blog post can optionally have a `comments_id` field in its frontmatter that maps to a GitHub Issue number in this repo. When a post has `comments_id`, `_includes/comments.html` is included in the page and uses vanilla JavaScript to fetch comments from the GitHub API (`/repos/HunterGerlach/www.huntergerlach.com/issues/{comments_id}/comments`). Comments render directly on the post page. Readers click through to the linked GitHub Issue to leave a new comment.

### Adding comments to a new post

Set `comments_id: auto` in the post's frontmatter and push to `main`. The `create-comment-issues` workflow will automatically create a GitHub Issue and replace `auto` with the real issue number.

To add comments manually instead, create a GitHub Issue in this repo, note its number, and set `comments_id: <number>` in the frontmatter.

## Writing a New Blog Post

1. Create a file in `_posts/` named `YYYY-MM-DD-your-title-slug.md`.
2. Add frontmatter:

   ```yaml
   ---
   layout: post
   title: Your Post Title
   comments_id: 7
   tags:
   - topic
   - another-topic
   ---
   ```

   `comments_id` is optional — omit it if you don't want comments on the post. Set it to `auto` to have a GitHub Issue created automatically on push.

3. Write content in Markdown below the frontmatter.
4. Push to `main` — GitHub Pages builds and deploys automatically.

Posts are served at `www.huntergerlach.com/<title-slug>.html` (configured via `permalink: /:title.html` in `_config.yml`).

## Build & Deployment

Pushes to `main` trigger GitHub Pages' **built-in Jekyll build** (the "pages build and deployment" action visible in the Actions tab). There is one custom workflow, `create-comment-issues.yml`, which automatically creates GitHub Issues for posts with `comments_id: auto` and updates the frontmatter with the real issue number. The site is served at [www.huntergerlach.com](https://www.huntergerlach.com) via the `CNAME` file.

## Running Locally

1. Install Jekyll by following the [installation guide](https://jekyllrb.com/docs/installation/).
2. Clone this repository: `git clone https://github.com/HunterGerlach/www.huntergerlach.com.git`
3. Navigate to the repo: `cd www.huntergerlach.com`
4. Install dependencies: `bundle install`
5. Start the local server: `bundle exec jekyll serve`
6. Open `http://localhost:3000` in your browser (port configured in `_config.yml`).

## Contributing

PRs are welcome! If you have suggestions or changes, please submit a PR.

1. Fork this repository.
2. Clone your fork: `git clone https://github.com/YOUR-USERNAME/www.huntergerlach.com.git`
3. Create a branch: `git checkout -b my-new-branch`
4. Make your changes and commit: `git commit -am "Description of changes"`
5. Push to your fork: `git push origin my-new-branch`
6. Submit a PR from your fork to this repository.
