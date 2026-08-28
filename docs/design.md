# Design

The full, machine-readable record is [`DESIGN.md`](../DESIGN.md) (with a sidecar in `.impeccable/design.json`). This page is the short version.

## One idea

A person's page is a **poster**: the name set huge, everything else in order beneath it. No button stack, no fixed grid. Every section is exactly as tall as what it holds, so a thin page still reads as finished.

## Tokens

Defined once in `app/assets/stylesheets/theme_defaults.css`, light on `:root`, dark on `[data-theme="dark"]`:

| Token | Light | Dark | Used for |
|---|---|---|---|
| `--canvas` | `#F3F3F1` | `#0C0C0C` | page background |
| `--card` / `--card-2` / `--card-3` | white → `#ECECE9` | `#161616` → `#262626` | surfaces |
| `--line` / `--line-2` | `#E4E4E0` / `#D3D3CE` | `#262626` / `#343434` | hairlines |
| `--ink` / `--ink-2` / `--muted` / `--subtle` | `#111110` … `#A6A6A0` | `#F5F5F3` … `#5E5E5A` | type |
| `--accent` | `#3A3AF4` | `#8A8AFF` | links, focus, wordmark mark |
| `--ok` / `--warn` / `--danger` | green / amber / red | lighter variants | states, always paired with a `-soft` tint |

Radii: `--r-sm .5rem`, `--r-md .75rem`, `--r-lg 1.25rem`, `--r-card 1.5rem`, pills `999px`. One easing: `--ease-out: cubic-bezier(.16,1,.3,1)`.

## Type

Three self-hosted faces (`app/assets/fonts/`, OFL):

- **Bricolage Grotesque** — display: the name (`clamp(3rem, 9vw, 7rem)`, 800, −0.05em), chapter headings, landing h1.
- **Geist** — everything else, 1rem / 1.5.
- **Geist Mono** — handles, dates, hosts, counts, URLs.

## Colour rule

The canvas is neutral. Colour appears only where it carries meaning: brand-coloured glyph discs on links, the green current-role date, the green "available" state on the claim form, red for errors. Primary actions are ink.

## Surfaces

| Surface | Mode | Stylesheet |
|---|---|---|
| Public page + post | the product | `profile.css` |
| Landing | persuade | `landing.css` |
| Dashboard | operate | `workspace.css` |
| Onboarding, auth, static | operate | `gate.css` |
| Editor | operate | `actiontext.css` (Lexxy variables mapped to tokens) |
| Email | read | inline styles in `layouts/mailer.html.erb`, same hex values |

## Motion

One authored moment per surface: the poster rises in once (staggered, 640 ms), the landing sample frame rises after the copy, the claim field pulses twice on load, the sticky subscribe bar slides up. Hover states come from the primitives. Everything collapses under `prefers-reduced-motion`.

## Don'ts

No eyebrow labels above headings, no gradient text, no emoji as icons, no same-size icon-heading-text card grids, no nested cards, no colour picked by category. When in doubt, remove.
