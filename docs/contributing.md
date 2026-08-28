# Contributing

Pull requests are welcome. For anything larger than a fix, open an issue first so we can agree on the shape.

## Branch flow

```
feature/your-thing  →  dev  →  main
```

- Branch from `dev`. Open your PR against `dev`.
- `dev` and `main` are protected: changes land through pull requests.
- `main` is what's deployed.

## Before you push

```bash
bin/rails test
bin/rubocop
bin/brakeman --no-pager
```

CI runs the same three on every PR.

## Style

- Ruby: rubocop-rails-omakase, as configured. Don't fight it.
- Views: one ViewComponent per UI unit, with a test that asserts the markup that matters (ids, data attributes, copy), not every class.
- CSS: tokens and primitives in `theme_defaults.css`; surface-specific rules in that surface's file. No new Tailwind arbitrary `bg-[var(--x)]` soup — write a class.
- Design: read [design.md](design.md) and the "Don'ts" before adding UI. Empty sections don't render; colour means something; primary actions are ink.
- Copy: short, direct, no hype, no invented claims.

## Commit messages

Imperative subject, under ~70 characters, a body when the *why* isn't obvious. No trailers, no attribution footers.

```
Resume onboarding at the step the user left

Required steps still win; optional steps are remembered in the session.
```

## What a good PR looks like

- One concern. A redesign and a bug fix are two PRs.
- Screenshots for anything visual (light and dark if the change touches tokens).
- Tests updated in the same PR — a red suite is not "for later".
- Docs touched if behaviour changed (`docs/features.md`, `docs/architecture.md`).
