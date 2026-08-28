# Deployment

whoami deploys with [Kamal](https://kamal-deploy.org) to a single server: one Docker container, Thruster in front of Puma, SQLite on a persistent volume, Solid Queue running inside Puma. That is the whole diagram.

## What you need

- A server with Docker (the current config targets `65.109.229.30`, see `config/deploy.yml`)
- A container registry login (`KAMAL_REGISTRY_PASSWORD`)
- `config/master.key` → `RAILS_MASTER_KEY`
- Credentials in `config/credentials.yml.enc`: `postmark.api_token` (transactional email)
- DNS for the main host pointing at the server (`proxy.host` in `deploy.yml`, currently `whoami.tech`)

Secrets are read by `.kamal/secrets` from the environment — never commit raw values.

## Deploy

```bash
bin/kamal setup      # first time: installs Docker, proxy, boots the app
bin/kamal deploy     # every time after
```

Useful aliases (defined in `deploy.yml`):

```bash
bin/kamal console    # rails console in the container
bin/kamal shell
bin/kamal logs
bin/kamal dbc        # sqlite console
```

## Data

Everything lives in `/rails/storage` on the `volume-whoami` volume: `production.sqlite3` plus the `cache`, `queue` and `cable` databases, and Active Storage files (avatars, post attachments).

**Back it up.** A nightly `sqlite3 storage/production.sqlite3 ".backup /tmp/whoami.sqlite3"` copied off the box (R2/S3/anything) is the minimum; test a restore once in a while. Active Storage files are in `storage/` beside it.

## Email

Production sends through Postmark (`config/application.rb`). Set the token in credentials, verify the sender domain in Postmark, and make sure `config.action_mailer.default_url_options` in `production.rb` matches the host — confirmation and unsubscribe links are built from it.

## Jobs and cable

Solid Queue runs inside the web process (`SOLID_QUEUE_IN_PUMA: true`), so there is no separate worker to run. Solid Cable backs Action Cable (used by the in-place subscribe confirmation). Both use their own SQLite databases on the same volume.

## Cloudflare

If the domain is proxied through Cloudflare, set **SSL/TLS → Full** (Kamal's proxy terminates TLS with a Let's Encrypt certificate; "Flexible" will produce 525/redirect loops).

## Custom domains

The app answers on any host saved as a user's custom domain, but it does not obtain certificates for those hosts. Options, from simplest:

1. Tell users to CNAME to the main host and put Cloudflare (proxied, SSL Full) in front on *their* zone — Cloudflare terminates TLS, the origin sees the host header.
2. Add each host to `proxy.host` in `deploy.yml` (comma-separated) so kamal-proxy requests a certificate for it, and redeploy. Fine for a handful of domains.
3. For many domains, put a proxy with on-demand TLS (e.g. Caddy) in front.

## Checklist before a release

- `bin/ci` green (rubocop, importmap audit, brakeman, tests, seeds)
- `bin/rails tailwindcss:build` output committed? No — assets build in the Docker image (`assets:precompile`), nothing to commit.
- Migrations run automatically on boot via `bin/docker-entrypoint` (`db:prepare`).
