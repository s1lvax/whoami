# Features

What each part of whoami does, from the user's side, with the file to open if you want to change it.

## The public page (`/:username`)

A poster: name set huge, handle, bio, a photo at the right (first and centred on phones). Then:

- **Links** — up to six, each a row with a brand-coloured glyph (GitHub, X, LinkedIn, YouTube, Bluesky, Mastodon, Instagram, … 20 hosts recognised; anything else gets a neutral arrow), the label and the host. Clicks are counted through `/links/:id/click`.
- **Work** — entries ordered current-first; the current role's date is green with a live dot. Highlights and tech chips per entry.
- **Writing** — published posts with date and excerpt, paginated, plus a compact "new posts by email" row.
- Empty sections are not rendered. A page with a name and two links is a finished page.

Components: `app/components/public_profile/*`. Styles: `app/assets/stylesheets/profile.css`.

## Posts (`/:username/posts/:slug`)

Title, excerpt, byline (author, date, reads), the body in `.prose`, then a three-dot end mark, a one-line subscribe strip, "More writing", footer. A **Subscribe** pill in the header jumps to the strip; a **sticky bar** slides in once the reader is 35% through (or after 8 s), hides while the strip is visible, and stays dismissed for 30 days once closed.

## Newsletter

- Readers subscribe from the post strip, the sticky bar, or the profile's Writing section. The form swaps in place to *"Check your inbox"*; when they click the emailed link, that page updates to *"You're in"* over Action Cable.
- Owners see confirmed subscribers under **Audience** on the dashboard and can remove them.
- Publishing a post with **Email this to N subscribers** ticked sends it once via `NewsletterBroadcastJob`. With no subscribers the editor says so and offers a copy-link button instead.
- Every email links to a one-click unsubscribe. Mailers: `app/mailers/subscription_mailer.rb`, layout `app/views/layouts/mailer.html.erb`.

## Editor

Lexxy (Lexical-based Action Text editor): `#`, `**bold**`, `-`, `>`, ``` ``` ``` and paste-to-link work as you type; code blocks highlight. The editor page has a sticky bar with a **Published** switch and Save, a borderless title and excerpt, and the body on a bordered "paper". Component: `app/components/dashboard/post_form_component.*`; theme: `app/assets/stylesheets/actiontext.css`.

## Dashboard (`/dashboard`)

A workshop: sidebar nav, sections for Profile, Links, Work, Writing, Audience, Domain, and a **live phone preview** on the right (from 1024px; a floating Preview button below that). Inline Turbo forms for links and work. While you type in any of them, the preview shows the draft before you save; every save reloads it.

## Onboarding

Claim a handle on the landing page (live availability, green when free) → sign up → confirm email → five steps: name, username (pre-filled if claimed), bio, links, avatar → **"Your page is live — put it somewhere"** with copy buttons and direct links to the profile-settings pages of GitHub, LinkedIn, X, Instagram, Bluesky, plus an email-signature snippet. Reachable later as **Share** in the dashboard nav.

Leaving mid-way is fine: every step saves, and you resume where you stopped.

## GitHub import

From onboarding step 2 or the dashboard: enter a public GitHub username and name, bio, avatar and the profile's links are pulled in. Code: `app/models/github/`.

## Custom domains

Save a hostname under **Domain**. Point a CNAME (or A record) at the app; the page, posts and feed answer on that host with the same content. The app does not provision DNS or certificates for you — see [deployment.md](deployment.md#custom-domains).

## Themes

Light or dark follows the operating system; the toggle (landing nav, page footer, gate pages) overrides it and remembers the choice in `localStorage`.

## Accounts

Devise: sign up with email + password, confirmation required, password reset, account settings, delete account. All Devise views and emails use the app's design.
