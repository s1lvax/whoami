# Whoami roadmap

Whoami is the one link you put everywhere: signature, bios, slides.
Not Linktree. Not LinkedIn. Not a blog platform.

The look is **Poster**: the name set huge, handle and bio beneath it, links
as a brand-coloured index, Work and Writing as chapters. Neutral canvas, ink
type, colour only where it means something. Light or dark follows the system.
Bricolage Grotesque for display, Geist for text, Geist Mono for handles, dates
and URLs. Recorded in [DESIGN.md](../DESIGN.md); summarised in [design.md](design.md).

## Now — local, visual system

1. Poster on the public page; the same tokens on landing, dashboard, onboarding, auth and email. (done)
2. Public page is the product; every section content-height. (done)
3. Landing tells the truth. Drop fake claims (CV download, “join creators”).
4. Dashboard, onboarding, and Devise inherit the same tokens. (done)

## Next — still local, still the same product

5. Dashboard as a workshop for the public page — edit links and work (done).
6. Onboarding lands on the live page; owner can Edit back to the dashboard (done).
7. Empty states that look like the page, not “No links yet.”

## Features in

- GitHub import (onboarding + dashboard): name, bio, avatar, links.
- Newsletter: owner can see and remove confirmed subscribers.
- Dashboard empty states for links, work, posts, subscribers.
- Custom domain: save a hostname, the public page answers on that host.

## Not yet

Theme marketplace. DNS/SSL for the domain at launch.

## Then — launch

8. Fix the Cloudflare 525 on whoami.tech.
9. Deploy this branch.
10. Do not add surface after that until the live page is something you would keep.
