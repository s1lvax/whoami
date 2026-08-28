# Architecture

whoami is a conventional Rails 8 monolith. There is one app, one process, one SQLite file per concern (data, cache, queue, cable), and HTML over the wire.

## Stack

| Layer | Choice | Notes |
|---|---|---|
| Framework | Rails 8.0, Ruby 3.4 | Propshaft assets, importmap JS, no bundler |
| Frontend | Hotwire (Turbo + Stimulus), ViewComponent | Every UI unit is a component under `app/components` |
| Styling | Tailwind CSS 4 utilities + hand-written CSS | Design tokens and themes in `theme_defaults.css`; Tailwind is used for spacing/flex utilities only |
| Auth | Devise | `database_authenticatable, registerable, recoverable, rememberable, validatable, confirmable` |
| Rich text | Action Text with Lexxy | Markdown shortcuts, code highlighting, attachments via Active Storage |
| Data | SQLite | Solid Queue (jobs), Solid Cache, Solid Cable (production); `:async` cable and jobs in development |
| Email | Postmark (`postmark-rails`) | letter_opener in development |
| Deploy | Kamal + Thruster | One server, Docker image, persistent volume for `storage/` |

## Directory map

```
app/
  components/            ViewComponents (dashboard/, landing/, onboarding/, public_profile/)
  controllers/
    concerns/public_page.rb      resolves the user from :username or a custom domain host
    concerns/visit_tracking.rb   de-duplicated view/click counting
    dashboard/                   favorite_links, experiences, posts, subscribers, drafts
    dashboard_controller.rb      show / edit / update / share
    onboardings_controller.rb    5-step flow + public check_username
    profiles_controller.rb       the public page
    public_posts_controller.rb   a single post
    subscriptions_controller.rb  subscribe / confirm / cancel
  helpers/
    application_helper.rb        domain-aware URL helpers (public_profile_path_for, …)
    link_icon_helper.rb          brand glyphs + brand colours per host
  javascript/controllers/        Stimulus: theme, username_check, draft, preview, clipboard, toast,
                                 subscribe_bar, links, avatar_preview
  jobs/newsletter_broadcast_job.rb
  mailers/subscription_mailer.rb
  models/                        User, FavoriteLink, Experience, Post, Subscription, Github::*
  assets/stylesheets/            theme_defaults, profile, landing, workspace, gate, actiontext, theme_toggle
  assets/fonts/                  Bricolage Grotesque, Geist, Geist Mono (woff2, OFL)
docs/                            these files
DESIGN.md · PRODUCT.md           recorded design system and product truth
```

## Models

```
User ──< FavoriteLink   (max 6, ordered, click counter)
     ──< Experience     (role, company, location, dates, highlights, tech; end_date nil = current)
     ──< Post           (title, excerpt, Action Text body, status draft|published, slug, views,
                         send_to_newsletter, newsletter_sent)
     ──< Subscription   (subscriber_email, token, confirmed, canceled)
     has_one_attached :avatar
```

`User` also carries `username` (handle; 3–30 `[a-z0-9]`, reserved words excluded), `custom_domain`, `visits`, and the onboarding flags `onboarded` / `onboarded_at`.

## Routes worth knowing

| Path | Purpose |
|---|---|
| `/` | Landing (marketing + claim form) |
| `/:username` | Public page (constraint: valid handle) |
| `/:username/posts/:slug` | A post |
| `/:username/feed` | RSS |
| `/:username/links/:id/click` | Click tracking → redirect |
| `/:username/subscribe` · `/:username/:token/confirm` · `/:username/:token/cancel` | Newsletter |
| `/onboarding?step=` · `/onboarding/check_username` | Onboarding; the availability check is public |
| `/dashboard` · `/dashboard/edit` · `/dashboard/share` | Workshop |
| `/dashboard/favorite_links`, `/experiences`, `/posts`, `/subscribers` | CRUD, mostly Turbo Frames/Streams |
| `/dashboard/draft/link` · `/dashboard/draft/experience` | Render an unsaved record through the public components (live preview drafts) |

When a request arrives on a **custom domain**, a routing constraint (`User.custom_domain?(host)`) maps the same actions to `/`, `/posts/:slug`, `/feed`, … for that user. Always build public URLs with the `*_for` helpers in `ApplicationHelper` — they know which form to use.

## Flows that matter

**Claiming a handle.** Landing form → `username-check` Stimulus controller → `GET /onboarding/check_username` (public) → status frame. Submit → `/users/sign_up?username=x` → hidden field → saved on the user at registration → pre-filled and "available" at onboarding step 2.

**Onboarding.** Five PATCHes to `/onboarding?step=` (name, username, bio, links, avatar). Each step saves. Returning users resume at the first required step still missing, otherwise at the optional step they left (remembered in the session). Finishing lands on `/dashboard/share`.

**Live preview.** The dashboard embeds `/:username?preview=1` in an iframe. `preview_controller` reloads it after any Turbo submit. `draft_controller` on the inline forms paints unsaved values into the iframe while typing — links and work via the draft endpoints (real components, nothing saved), profile text directly.

**Subscribing.** Forms post with `variant` (card / bar / inline). `SubscriptionsController#subscribe` answers with a Turbo Stream that replaces that variant with a pending state containing `turbo_stream_from "subscription:<token>"`. `#confirm` (from the email link) broadcasts a replace to that stream, so the page the reader left open flips to confirmed. Publishing a post with *send to newsletter* enqueues `NewsletterBroadcastJob`, which mails every confirmed subscriber once.

**Counting.** `VisitTracking` increments profile visits, link clicks and post reads once per visitor per window, ignoring the owner.
