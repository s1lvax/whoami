# whoami

**One link. All of you.** whoami is a self-hosted personal page — the link you put in your email signature, your bios and your slides. Name, work history, links, writing and a newsletter, on one page you own.

Built with Rails 8, Hotwire and SQLite. No JavaScript framework, no build step, one server.

- Live: [whoami.tech](https://whoami.tech) · example page: [whoami.tech/cfds](https://whoami.tech/cfds)
- License: MIT

## What you get

| | |
|---|---|
| **A poster page** | Your name set big, a handle, a bio, a photo. Links as a brand-coloured index, Work as a timeline, Writing with excerpts. Every section is only as tall as its content, so a page with two links looks finished. |
| **Writing** | A Markdown-friendly editor (Lexxy), drafts and publishing, per-user RSS, an end-of-post subscribe strip. |
| **Newsletter** | Readers subscribe in place and confirm by email; the page they're on updates live when they do. Published posts go out to confirmed subscribers automatically. |
| **Workshop dashboard** | Edit links, work, profile and posts beside a live phone preview that repaints as you type. |
| **Onboarding** | Claim a handle on the landing page, five short steps, then a "put your link somewhere" screen. |
| **Custom domains** | Point a hostname at the app and your page answers there. |
| **GitHub import** | Fill name, bio, avatar and links from a public GitHub profile. |
| **Light and dark** | Follows the system, one toggle to override. |

## Quick start

```bash
git clone https://github.com/s1lvax/whoami.git && cd whoami
bundle install
bin/rails db:prepare db:seed
bin/dev
```

Open http://localhost:3000. Seeded demo account: `dev@localhost.test` / `password123` (page at `/cfds`). In development every email opens in your browser via letter_opener.

## Documentation

| Doc | What's in it |
|---|---|
| [docs/getting-started.md](docs/getting-started.md) | Requirements, setup, seeds, dev server, emails in development, common tasks |
| [docs/architecture.md](docs/architecture.md) | Stack, directory map, models, routes, the request flows that matter |
| [docs/features.md](docs/features.md) | How each feature works, end to end |
| [docs/design.md](docs/design.md) | The visual system in one page; links to `DESIGN.md` for the full record |
| [docs/deployment.md](docs/deployment.md) | Kamal, secrets, SQLite on a volume, email, backups, custom domains in production |
| [docs/testing.md](docs/testing.md) | Test layout, running the suite, CI, screenshot tricks |
| [docs/contributing.md](docs/contributing.md) | Branch flow, commit style, what a good PR looks like |
| [docs/roadmap.md](docs/roadmap.md) | Where this is going |
| [PRODUCT.md](PRODUCT.md) / [DESIGN.md](DESIGN.md) | Product truth and the recorded design system |

## Tech stack

Ruby 3.4 · Rails 8.0 · Hotwire (Turbo, Stimulus) · Tailwind CSS 4 (utilities only; the design lives in hand-written CSS with tokens) · SQLite via Solid Queue / Solid Cache / Solid Cable · ViewComponent · Devise · Lexxy (Action Text) · Postmark · Kamal + Thruster.

## Author

Cesário Silva — [whoami.tech/cfds](https://whoami.tech/cfds)
