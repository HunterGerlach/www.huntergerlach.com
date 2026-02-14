# ADR 0001: Use GitHub Issues for Comments

**Date:** 2022-12-31
**Status:** Accepted

## Context

The blog needed a comment system. Three factors drove the decision:

1. **Minimize dependencies** — third-party comment services (Disqus, Utterances, Giscus) add external JavaScript, tracking, and vendor lock-in. GitHub was already in use for hosting, so leveraging it for comments adds no new dependency.
2. **Lower the barrier to contributing** — people who read and share posts may not be developers yet. Directing them to GitHub Issues gives them an on-ramp to a platform that could spark their interest in development.
3. **Use what we already have** — the site is hosted on GitHub Pages, the repo is on GitHub, and the audience is likely adjacent to the developer community.

## Decision

Use GitHub Issues as the comment backend. Each blog post can reference a GitHub Issue via `comments_id` in its frontmatter. Client-side JavaScript fetches comments from the GitHub API and renders them on the post page. Readers leave comments by clicking through to the linked GitHub Issue.

A GitHub Actions workflow (`create-comment-issues.yml`) automatically creates Issues for new posts with `comments_id: auto` and updates the frontmatter with the real issue number.

## Consequences

- **No third-party comment service** — no external JS, no tracking, no vendor lock-in.
- **Comments are durable** — stored in GitHub Issues, exportable, searchable.
- **Barrier to comment** — readers need a GitHub account and must navigate to the Issue page.
- **Rate limits** — unauthenticated GitHub API requests are limited to 60/hour per IP.
- **Security surface** — comment HTML from the API must be sanitized before rendering (addressed in ADR 0005).
