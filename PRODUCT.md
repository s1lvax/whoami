# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Anyone who needs one public URL to put everywhere — email signature, social
bios, slides, a CV: developers, designers, founders, freelancers. They arrive from
a link someone else clicked; the owner visits the dashboard occasionally to
update links, work history, or publish a post.

Secondary: recruiters and peers landing on a profile from a link. They need to
know within seconds who this person is, what they do, and where else to find them.

## Product Purpose

Whoami is a self-hosted (or hosted at whoami.tech) personal homepage:
name, avatar, bio, up to six links, work experience, writing, newsletter.
It exists because GitHub is a repo, LinkedIn is a feed, and Linktree is a
stack of buttons — none is a homepage you own. Success: a profile that
someone would actually keep as their canonical URL, and a page that loads
fast and reads clearly for the visitor.

## Positioning

"One link for all of you." Work history and writing are first-class, not
add-ons; the page is a poster, not a list of buttons. Open source (MIT), Rails 8,
self-hostable, custom domains, GitHub import, RSS, newsletter. No ads, no
"pro" tier, no feed.

## Operating Context

- Public page at `/:username` or on a custom domain (domain-aware path helpers
  in `ApplicationHelper` — `public_profile_path_for` etc. must be used).
- Dashboard at `/dashboard` for the owner; onboarding is a 5-step flow
  (name → username → bio → links → avatar).
- Posts written in Trix/ActionText; posts can be broadcast to newsletter
  subscribers.
- Deployed single-server via Kamal; SQLite; Propshaft; importmap; no Node.

## Capabilities and Constraints

- Tailwind v4 (standalone CLI, no config file) + hand-written CSS variables.
  Dark/light via `data-theme` on `<html>`, persisted in localStorage.
- ViewComponent for every UI unit; Minitest component tests assert on markup.
- Max six favorite links per user (model validation).
- No per-user theming (roadmap: "not yet").
- No `og:image` generation.
- Devise views are custom-styled except `unlocks/new` and the mailers.

## Brand Commitments

- Name: **whoami** (lowercase wordmark). Domain whoami.tech.
- Voice: short, direct, slightly contrarian ("LinkedIn is a feed. Linktree is
  a list of buttons."). No hype, no fake social proof.
- *(inferred from this request)* The previous "Deep Field" near-black
  starfield look is being replaced by a complete redesign inspired by the
  current link-in-bio / personal-page category.

## Evidence on Hand

- A real seeded profile (`cfds`, Cesário Silva) used as the live sample on
  the landing page.
- README feature list. No testimonials, no user counts, no press — do not
  invent any.
- Local Inter font files in `app/assets/fonts/` (currently unused).

## Product Principles

1. The public page is the product; everything else serves it.
2. Empty sections don't render — a name and two links is a finished page.
3. One identity across landing, onboarding, dashboard, auth, email.
4. Fast and plain HTML first; motion is decoration, never a dependency.
5. Honest copy: no claims the product can't back.

## Accessibility & Inclusion

Keyboard-visible focus rings, semantic headings per section, `prefers-reduced-motion`
respected, WCAG AA contrast in both themes.
