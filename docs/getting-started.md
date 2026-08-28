# Getting started

## Requirements

- Ruby **3.4.5** (see `.ruby-version`)
- SQLite 3 (bundled via the `sqlite3` gem)
- libvips (for avatar variants via `image_processing`)
- Chromium or Chrome, only if you want to run system tests or take screenshots

No Node, no Yarn. JavaScript ships through importmap; Tailwind runs through the standalone binary in `tailwindcss-ruby`.

## Setup

```bash
git clone https://github.com/s1lvax/whoami.git
cd whoami
bundle install
bin/rails db:prepare        # creates and migrates development + test databases
bin/rails db:seed           # demo user, links, work, a post
bin/dev                     # Rails server + Tailwind watcher (Procfile.dev)
```

Open http://localhost:3000.

### Seeded accounts

| Email | Password | State |
|---|---|---|
| `dev@localhost.test` | `password123` | Onboarded. Handle `cfds`, page at `/cfds`, one published post. |

Create more with the sign-up form. Confirmation emails open in your browser (see below), so the whole flow works locally.

## Emails in development

`config/environments/development.rb` sets `delivery_method = :letter_opener`. Every email — sign-up confirmation, password reset, newsletter confirmation, welcome, post broadcasts — opens as a browser tab the moment it is "sent", with the real links inside. Copies are kept in `tmp/letter_opener/`.

Jobs run in-process (`:async`) in development, so `deliver_later` is effectively immediate.

## Everyday commands

| Task | Command |
|---|---|
| Run the app | `bin/dev` (or `bin/rails server` if you don't need the Tailwind watcher) |
| Rebuild Tailwind once | `bin/rails tailwindcss:build` (only needed when you add new utility classes) |
| Console | `bin/rails console` |
| Tests | `bin/rails test` — see [testing.md](testing.md) |
| Lint | `bin/rubocop` (rubocop-rails-omakase) |
| Security scan | `bin/brakeman --no-pager` |
| Reset the DB | `bin/rails db:reset` |

## Editing the design

- Tokens, primitives and both themes: `app/assets/stylesheets/theme_defaults.css`
- Per-surface stylesheets: `profile.css` (public page + post), `landing.css`, `workspace.css` (dashboard), `gate.css` (onboarding/auth), `actiontext.css` (editor)
- Stylesheet order is explicit in `app/views/layouts/application.html.erb` — later files override earlier ones, so add new files there deliberately.
- The full system is recorded in [`DESIGN.md`](../DESIGN.md); the one-page summary is [design.md](design.md).

## Troubleshooting

- **"database is locked" in tests** — two test runs are sharing `storage/test.sqlite3`. Wait for the other to finish.
- **Avatars don't render** — install libvips (`sudo apt install libvips` / `brew install vips`).
- **Screenshots come out dark** — headless Chromium follows your desktop's colour scheme; see [testing.md](testing.md#screenshots).
