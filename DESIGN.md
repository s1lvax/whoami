---
name: whoami
description: One link for all of you — a public page that is a poster, not a stack of buttons.
colors:
  canvas: "#F3F3F1"
  card: "#FFFFFF"
  card-2: "#F7F7F5"
  card-3: "#ECECE9"
  line: "#E4E4E0"
  line-2: "#D3D3CE"
  ink: "#111110"
  ink-2: "#3D3D3A"
  muted: "#72726D"
  subtle: "#A6A6A0"
  accent: "#3A3AF4"
  accent-soft: "#ECECFE"
  ok: "#0F7B4F"
  ok-soft: "#E3F5EC"
  warn: "#9A5B00"
  warn-soft: "#FBEFD8"
  danger: "#C0262D"
  danger-soft: "#FBE7E8"
  glyph-ink: "#FFFFFF"
typography:
  display:
    fontFamily: "Bricolage Grotesque, Geist, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(3rem, 9vw, 7rem)"
    fontWeight: 800
    lineHeight: 0.92
    letterSpacing: "-0.05em"
    fontVariation: "'opsz' 96"
  headline:
    fontFamily: "Bricolage Grotesque, Geist, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(2rem, 4vw, 3rem)"
    fontWeight: 700
    lineHeight: 1.02
    letterSpacing: "-0.03em"
    fontVariation: "'opsz' 96"
  section:
    fontFamily: "Bricolage Grotesque, Geist, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(1.75rem, 3vw, 2.25rem)"
    fontWeight: 750
    lineHeight: 1
    letterSpacing: "-0.035em"
    fontVariation: "'opsz' 96"
  index:
    fontFamily: "Bricolage Grotesque, Geist, ui-sans-serif, system-ui, sans-serif"
    fontSize: "clamp(1.25rem, 2.6vw, 1.75rem)"
    fontWeight: 650
    lineHeight: 1.1
    letterSpacing: "-0.025em"
  title:
    fontFamily: "Bricolage Grotesque, Geist, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.25rem"
    fontWeight: 650
    lineHeight: 1.15
    letterSpacing: "-0.02em"
  body:
    fontFamily: "Geist, ui-sans-serif, system-ui, -apple-system, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.5
    fontFeature: "'ss01', 'cv11'"
  label:
    fontFamily: "Geist, ui-sans-serif, system-ui, -apple-system, sans-serif"
    fontSize: "0.8rem"
    fontWeight: 550
    lineHeight: 1.4
  mono:
    fontFamily: "Geist Mono, ui-monospace, SFMono-Regular, Menlo, monospace"
    fontSize: "0.8rem"
    fontWeight: 400
    fontFeature: "'tnum'"
rounded:
  sm: "0.5rem"
  md: "0.75rem"
  glyph: "1rem"
  lg: "1.25rem"
  card: "1.5rem"
  photo: "2rem"
  pill: "999px"
spacing:
  gap-tight: "0.75rem"
  gap: "1.25rem"
  pad: "1.5rem"
  pad-lg: "2rem"
  poster-section: "3.5rem"
  poster-section-lg: "4.5rem"
  section: "4rem"
  section-lg: "6rem"
components:
  button-primary:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.canvas}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    padding: "0.66rem 1.05rem"
  button-primary-hover:
    backgroundColor: "#2B2B29"
  button-secondary:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    padding: "0.66rem 1.05rem"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.muted}"
    rounded: "{rounded.md}"
    padding: "0.66rem 1.05rem"
  button-ghost-hover:
    backgroundColor: "{colors.card-3}"
    textColor: "{colors.ink}"
  button-accent:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.card}"
    rounded: "{rounded.md}"
    padding: "0.66rem 1.05rem"
  button-danger:
    backgroundColor: "transparent"
    textColor: "{colors.danger}"
    rounded: "{rounded.md}"
    padding: "0.66rem 1.05rem"
  button-lg:
    rounded: "{rounded.lg}"
    padding: "0.9rem 1.4rem"
  button-sm:
    rounded: "{rounded.sm}"
    padding: "0.42rem 0.75rem"
  input:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    padding: "0.62rem 0.85rem"
  chip:
    backgroundColor: "{colors.card-2}"
    textColor: "{colors.ink-2}"
    rounded: "{rounded.pill}"
    padding: "0.2rem 0.6rem"
  chip-accent:
    backgroundColor: "{colors.accent-soft}"
    textColor: "{colors.accent}"
    rounded: "{rounded.pill}"
  chip-ok:
    backgroundColor: "{colors.ok-soft}"
    textColor: "{colors.ok}"
    rounded: "{rounded.pill}"
  chip-poster:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.pill}"
    padding: "0.2rem 0.6rem"
  card:
    backgroundColor: "{colors.card}"
    textColor: "{colors.ink}"
    rounded: "{rounded.card}"
    padding: "{spacing.pad}"
  poster:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    padding: "1.75rem 2.5rem 4rem"
  poster-link:
    textColor: "{colors.ink}"
    typography: "{typography.index}"
    padding: "1.35rem 0.5rem"
  poster-glyph:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.glyph-ink}"
    rounded: "{rounded.glyph}"
    size: "3rem"
  poster-photo:
    rounded: "{rounded.photo}"
    size: "14rem"
  row-current:
    textColor: "{colors.ok}"
    typography: "{typography.mono}"
  url-pill:
    backgroundColor: "{colors.card}"
    textColor: "{colors.muted}"
    typography: "{typography.mono}"
    rounded: "{rounded.pill}"
    padding: "0.35rem 0.75rem"
  switch-track:
    backgroundColor: "{colors.line-2}"
    rounded: "{rounded.pill}"
    width: "2.4rem"
    height: "1.4rem"
  switch-track-on:
    backgroundColor: "{colors.ok}"
  flash:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.canvas}"
    rounded: "{rounded.lg}"
    padding: "0.7rem 1.1rem"
---

# Design System: whoami

## Overview

**Creative North Star: "The Poster"**

A person's page is a poster: one name set huge, everything else in order beneath it. It stands on the same soft-grey canvas as the rest of the product, in the same ink, and type does all the work: the name at up to 7rem in Bricolage Grotesque, the handle and the one-line bio under it, then the links as a hairline index, then Work and Writing as ledgers under big Bricolage headings. Every section is exactly as tall as what it holds, so a page with a name and two links is a finished poster, not a grid with holes.

Colour on the poster comes from outside: each link's glyph sits in a 3rem disc filled with its platform's brand colour, white glyph on top, and the current job's date in the Work ledger is green with a pulsing dot. Nothing else on the page is coloured. The same canvas and ink carry the landing page (whose hero sample is a miniature of the real poster in a browser frame), the owner's workshop (white cards, a phone-framed live preview of the same page that repaints as the owner types), the gate (one column, one card), the editor (the text is the interface) and email (same hex values, table layout). Ink carries every primary action; a single ultramarine accent is reserved for links in prose, focus, live state and the fallback disc colour for unknown hosts.

Three type voices: Bricolage Grotesque speaks (name, section headings, index labels, row titles, wordmark), Geist works (body, buttons, labels), Geist Mono measures (handle, dates, hosts, counts, URLs).

**Key Characteristics:**
- Grey canvas and ink type everywhere, the poster included; light and dark are the same system with swapped tokens, selected by `data-theme` on `<html>`.
- Content-height sections divided by hairlines; no grid, no tiles, no cards on the public page.
- Links are an index (brand-coloured glyph disc, label, host, arrow), not buttons.
- The only colour on the poster belongs to someone else's brand (the discs) or to the one live state (the green current-job date).
- Ink primary actions everywhere; the accent is never a button colour on product surfaces.
- 1.5rem corners on cards, 2rem on the poster photo, 1rem on glyph discs; pills for chips, URLs and toggles.

## Colors

A warm-grey neutral scale carries every surface and all text; one ultramarine accent and three state hues appear only as tints, dots or small marks; saturated fills arrive from outside via the link discs.

### Primary
- **Ultramarine** (`accent`): links in prose, the wordmark's rotated square, focus rings (35% alpha), selection (18%), the caret, the landing claim field's focus border, Lexxy's link and selection colours, and the fallback fill for a glyph disc whose host has no brand entry. Dark mode lifts the text role to `#8A8AFF` while fills that carry white text stay `#3A3AF4`.
- **Ultramarine Tint** (`accent-soft`): accent chips, the confirmation glyph badge on the gate, Lexxy's selected-node highlight.

### Secondary
- **Now Green** (`ok`) on **Now Tint** (`ok-soft`): the current job's date in the Work ledger (green text with a 0.5rem pulsing dot), the "Published" chip and switch track, the workshop's Live dot, the domain-verified dot, the flash's success dot, the `is-done` state after copying a link.

### Tertiary
- **Amber** (`warn` / `warn-soft`) and **Red** (`danger` / `danger-soft`): notices, chips, field errors, the danger button's text, the flash's alert dot, Lexxy's red. Never fills.

### Neutral
- **Canvas** (`canvas`): the page background on every surface, the poster included; text on ink buttons and the CTA band.
- **Card** (`card`): trays, inputs, the URL pill, the theme toggle, the editor paper, the sample frame; on the poster, the fill of tech chips and the pager's ghost hover.
- **Card 2** (`card-2`): nested surfaces — chips, inline forms, code blocks, the sample frame's address bar, Lexxy's code and table-header background.
- **Card 3** (`card-3`): ghost-button hover, the landing CTA button hover, the landing avatar fallback.
- **Line** (`line`) and **Line 2** (`line-2`): hairlines (cards, rows, dividers, the poster's index and ledger rows, the editor toolbar) and stronger strokes (inputs, dashed empties, the switch track at rest, Lexxy's lighter ink).
- **Ink** (`ink`), **Ink 2** (`ink-2`), **Muted** (`muted`), **Subtle** (`subtle`): the name, headings, labels and row titles; bio, notes and excerpts; handle, hosts, dates, locations, counts, footer links, the editor toolbar; placeholders and the editor's help line.
- **Glyph White** (`glyph-ink`): the brand glyph inside a disc, always white regardless of brand or theme.

### Named Rules
**The Brand-Owns-Colour Rule.** Saturated fills come from the link's platform (`LinkIconHelper::BRANDS`, set inline as `--brand`), never from the palette. A disc with an unknown host falls back to ultramarine. Near-black brands (GitHub, X, Threads, Medium, dev.to, TikTok) stay near-black; an inset 1px white ring (8%, 14% in dark) separates every disc from the canvas.

**The Poster Aliases Rule.** `.poster` defines `--poster-bg/ink/text/muted/line/panel` as aliases of `canvas/ink/ink-2/muted/line/card` and every poster rule reads the alias, so the public page is the app's own surface in both themes and a future poster material would be one block to change.

**The Ink Action Rule.** Every primary action is ink on canvas (`button-primary`). The accent button exists but is not used on product surfaces; the accent's job is links, focus, live state and the fallback disc.

**The Tint-Not-Fill Rule.** State colours (`ok`, `warn`, `danger`, `accent`) appear as text on their `-soft` tint, as a 0.4–0.55rem dot, or as the switch track when on. They never fill a button or a whole card.

## Typography

**Display Font:** Bricolage Grotesque (self-hosted variable woff2, weight 200–800, width 75–100%; fallback Geist, then system sans)
**Body Font:** Geist (self-hosted variable woff2, 100–900; fallback system sans)
**Label/Mono Font:** Geist Mono (self-hosted variable woff2; fallback ui-monospace)

**Character:** Bricolage at the 96 optical size and heavy weights (650–800) with tight tracking gives the name a poster's presence and the index its rhythm; Geist keeps everything else even; Geist Mono with tabular figures makes the handle, dates, hosts and counts read as data.

### Hierarchy
- **Display** (800, `clamp(3rem, 9vw, 7rem)`, 0.92, -0.05em, opsz 96): the person's name, and only the name. Balanced wrapping, `overflow-wrap: anywhere` so a long name never escapes the column. In the landing sample it is 2.5rem.
- **Headline** (700, `clamp(2rem, 4vw, 3rem)` for landing sections and the CTA band, `clamp(3rem, 7vw, 5.5rem)` for the landing hero, `clamp(2rem, 5vw, 3rem)` at -0.035em for post titles; 1.02, -0.03em): landing headings and the read-page post title. The editor's title field is the same voice at 750 / `clamp(2rem, 4.5vw, 3rem)` / -0.04em.
- **Section** (750, `clamp(1.75rem, 3vw, 2.25rem)`, 1, -0.035em, opsz 96): the poster's "Work" and "Writing" headings, with a 0.85rem mono count at the right baseline.
- **Index** (650, `clamp(1.25rem, 2.6vw, 1.75rem)`, 1.1, -0.025em): link labels in the poster index, single-line ellipsised, underlined 2px on hover. The poster's row titles (Work and Writing entries) use the same voice at `clamp(1.15rem, 2vw, 1.4rem)`, 1.2, -0.02em.
- **Title** (650, 1.25rem, 1.15, -0.02em): card headings on grey surfaces (`card-head h2`), the subscribe box heading, landing demo trays.
- **Body** (400, 1rem, 1.5; poster bio `clamp(1.1rem, 1.8vw, 1.35rem)` / 1.45 in `ink-2`, max 34rem; poster notes and excerpts 0.98rem / 1.55, excerpts max 42rem; prose 1.075rem / 1.7 max 68ch; editor 1.1rem / 1.7): everything written in Geist.
- **Label** (550, 0.8rem–0.925rem): field labels (`ink-2`), buttons (0.925rem), the owner bar link, the switch label.
- **Mono** (400, 0.72–0.95rem, `tnum`): the handle (0.95rem, `muted`, directly under the name), date gutters (0.8rem; 500 in `ok` when current), link hosts (0.8rem), counts (0.85rem), post meta, URL pills, the workshop's "Live" label, the editor's help line (0.72rem), numbered step badges on the landing.

### Named Rules
**The Three Voices Rule.** Bricolage speaks (name, section headings, index labels, row titles, wordmark), Geist works (body, labels, buttons), Geist Mono measures (anything that is a date, handle, host, URL or count). No fourth face; no system display face.

**The One Name Rule.** The 7rem display size belongs to the name alone. Nothing else on any surface is set above `clamp(3rem, 7vw, 5.5rem)` (the landing hero).

**The Tight-Heavy Rule.** Display, section, headline and index weights sit at 650–800 with negative tracking (-0.02em to -0.05em) and line-height at or below 1.2 (0.92 for the name, 1 for section headings). Body never tracks tighter than -0.015em.

## Layout

The public page is a single column: `.poster` fills at least the viewport with the canvas, and `.poster-body` is a 68rem column padded 1.25rem/1.25rem/3rem (1.75rem/2.5rem/4rem from 768px). Inside it the order is fixed and every block is content-height: the hero (name, handle 0.9rem below it, bio 1.25rem below that; 2rem/2.5rem vertical padding, 4.5rem/3.5rem from 768px; bottom hairline), the link index, then Work and Writing sections each with 3.5rem top padding (4.5rem from 768px) and 1.5rem between heading and first row, then the footer 3.5rem below the last section with a top hairline. Sections with no data are not rendered at all, and nothing changes height to compensate — a thin page is simply shorter. There is no top bar: the handle lives under the name.

When a photo is attached the hero becomes a two-column grid from 768px (`minmax(0, 1fr) 14rem`, 3rem gap, items aligned to the end) with the 14rem photo at the right and text left-aligned. Below 768px the photo comes first (`order: -1`), centred at 8.5rem with 1.75rem corners, and the hero centres everything under it (name, handle, bio; 1.25rem gap; the bio's 34rem measure auto-centred). Without a photo nothing moves and the hero stays left-aligned at every width.

Index rows are a three-column grid (`auto | minmax(0, 1fr) | auto`: disc, text, arrow), 1.1rem/0.25rem padding (1.35rem/0.5rem from 768px) with a bottom hairline each. Ledger rows are the shared `.row`: an 8.5rem mono date gutter plus fluid body from 640px, stacked below; top hairlines, 1.35rem vertical padding on the poster (1.1rem in trays), the first row without a hairline or top padding and the last without bottom padding.

Landing: sticky 85%-canvas blurred nav; hero as a two-column grid from 1024px (`1.05fr 0.95fr`, 4rem gap, min-height `min(100vh − 4rem, 52rem)`) with the claim form left and the sample right — a 34rem browser frame whose body is a real `.poster` at reduced scale (body padding 1.1rem/1.25rem/1.4rem, hero 1.5rem/1.4rem, name 2.5rem, handle 0.75rem, discs 2.25rem, rows 0.75rem, entrance animation off). Sections max 68rem with 4rem vertical padding (6rem from 1024px); demo cards on the landing stay white trays.

Workshop: single column; from 1024px the preview column appears (sticky, top 5rem; top 2rem from 1280px) and from 1280px the page is a three-column grid `15rem | fluid | 22rem` with a sticky left nav; max width 96rem, 1.25rem card gaps. The phone (`.ws-phone`, 9:19, 8px ink bezel, 2.25rem outside / 1.75rem inside) holds the public page at `?preview=1`, which suppresses the owner bar and entrance animation. Below 1024px the phone is replaced by a fixed bottom-right "Open your page" button with `lift-2`.

Editor: a 46rem column, 1.25rem side padding (2rem from 768px), 6–8rem bottom padding; a sticky bar bleeding to the column edges (88% canvas, 10px blur), then the bare title and excerpt fields, then the paper (white card, 1.5rem radius, 1rem/1.5rem padding) holding the Lexxy toolbar (sticky at 3.6rem) and the text.

Gate: one 27rem column, one card, 3rem top padding; step rail of five 4px pills that fill with ink as steps complete.

Post: 44rem measure, prose at 68ch. Email: 600px table, 24px-radius white card on canvas.

**The Content-Height Rule.** No block on the poster has a minimum height, a fixed row, or a span. Height is what the content needs plus the rhythm above (3.5–4.5rem per section, 1.1–1.35rem per row). A page with only a name and a bio is a finished page.

## Elevation & Depth

Depth is tonal by default: canvas below, white card on top, `card-2` for nested surfaces, hairlines to mark edges. The poster has no surfaces at all — only hairlines on the canvas, plus the brand discs (each with an inset 1px white ring at 8%, 14% in dark, so near-black brands separate from a dark canvas) and white chips. Shadows are reserved for things that float or lift: the landing sample frame, the phone, the preview FAB, the flash toast at rest and the poster photo (`lift-2`), and Lexxy's popovers (`lift`). Nothing on the poster lifts on hover; index rows slide and underline instead.

### Shadow Vocabulary
- **Lift** (`box-shadow: 0 10px 30px -14px rgba(17,17,16,0.28)`; dark `rgba(0,0,0,0.7)`): Lexxy's popovers and menus; otherwise defined but unused at rest.
- **Lift 2** (`box-shadow: 0 24px 60px -24px rgba(17,17,16,0.35)`; dark `rgba(0,0,0,0.8)`): the floating frames (sample, phone, FAB), the flash toast, the poster photo.
- **Disc ring** (`inset 0 0 0 1px rgba(255,255,255,0.08)`; dark `0.14`): every glyph disc.
- **Focus** (`0 0 0 3px` accent at 35%): every focusable element; inputs also switch the border to accent; the editor's title, excerpt and body suppress it (the caret is the focus).
- **Switch knob** (`0 1px 2px rgba(0,0,0,0.25)`): the one small contact shadow, on the 1.1rem knob of the Published switch.

### Named Rules
**The Flat-By-Default Rule.** Surfaces are flat at rest and separate by tone and hairline. A shadow means the thing is lifted off the page: a frame, a toast, a photo, a popover.

**The Hairline Poster Rule.** On the poster nothing is boxed: no card, no tray, no hover lift. Rows are separated by 1px `line` hairlines and by rhythm; the only filled shapes are the brand discs, the photo and the tech chips.

## Shapes

Big, soft, consistent: every card and tray is 1.5rem (`card`); the poster photo is 1.75rem at 8.5rem (mobile) and 2rem at 14rem; glyph discs are 1rem-radius 3rem squares (0.7rem at 2.25rem in the sample); buttons 0.75rem (`md`); large buttons, secondary containers (empties, inline forms, the editor's newsletter aside, "more posts" links, prose images) 1.25rem (`lg`); small buttons, icon buttons, code, the editor toolbar and focus outlines 0.5rem (`sm`); inline code 0.35rem. Chips, URL pills, the theme toggle, the switch track, step-rail segments, the landing address bar and scrollbar thumbs are full pills. Borders are 1px hairlines in `line`; stronger `line-2` on inputs and dashed on empties and add-buttons; the 2px left rule on editor blockquotes is the one thicker line. The wordmark's mark is a 0.7rem ultramarine square rotated 45° with a 0.2rem radius. The phone frame is 2.25rem outside / 1.75rem inside.

## Components

### Buttons
Quiet and solid: an ink slab is the primary, everything else is outlined or ghost.
- **Shape:** rounded (0.75rem); large 1.25rem; small and icon 0.5rem.
- **Primary:** ink on canvas, padding 0.66rem 1.05rem, Geist 0.925rem at weight 550; hover darkens to `#2B2B29` (dark mode: `#DADAD6`). Landing hero uses `btn-lg`; the editor bar uses `btn-sm`.
- **Hover / Focus:** 160ms colour transitions on the `ease-out` curve; focus is the 3px accent ring.
- **Secondary:** white with a `line-2` border; hover to `card-2` and `subtle` border. **Ghost:** transparent, muted text; hover ink on `card-3` (on the poster's pager, ink on `card`). **Accent:** ultramarine with white text (defined, unused on product surfaces). **Danger:** transparent, red text, `line-2` border; hover fills `danger-soft`. **Disabled:** 55% opacity. **Done:** after a copy, text and border turn `ok` for 1.6s.
- **Inverted:** on the ink CTA band the button flips to canvas-on-ink.

### Chips
- **Style:** `card-2` fill, hairline border, `ink-2` text, 0.75rem, pill, padding 0.2rem 0.6rem. Tech tags in Work rows (max five shown); status in the post header.
- **State:** `chip-accent` / `chip-ok` / `chip-warn` / `chip-danger` drop the border and use the tint + hue; `chip-dot` prefixes a 0.4rem currentColor dot (domain verified, published). On the poster a chip is `card` white with ink text and no border.

### Cards / Containers
- **Corner Style:** 1.5rem.
- **Background:** white on canvas; `card-2` for nested rows.
- **Shadow Strategy:** none at rest (see Elevation).
- **Border:** 1px `line`.
- **Internal Padding:** 1.5rem (`card-pad`, `tray`, the editor paper); 1.75rem for trays from 768px; 2rem for the gate card from 480px.
- **Head:** `card-head` puts a 1.25rem Bricolage title left, a mono `muted` count or link right, baseline-aligned, 1.1rem below. On the poster the same head carries the section heading at the section size and a 0.85rem count, 1.5rem below.

### Inputs / Fields
- **Style:** white, 1px `line-2` border, 0.75rem radius, padding 0.62rem 0.85rem, inherits Geist at 0.95rem; mono variant for handles and domains at 0.9rem. Labels 0.8rem/550 in `ink-2` above, hint and error 0.8rem below. Textareas min 6rem, vertical resize. The landing claim field is a pill-shaped compound (`whoami.tech/` prefix + input) whose whole box takes the accent border and ring on focus-within.
- **Focus:** border turns accent plus the 3px accent ring. Hover border `subtle`.
- **Error / Disabled:** `is-invalid` turns the border red; checkboxes take `accent-color: accent`; file inputs get a secondary-button-styled selector.
- **Bare fields:** the editor's title and excerpt are borderless, transparent, full-width fields with `subtle` placeholders ("Untitled", "One line that says what this is") and no focus ring.

### Switch
- **Style:** 2.4rem × 1.4rem pill track in `line-2` with a 1.1rem white knob (contact shadow); checked fills the track `ok` and slides the knob 1rem over 240ms. Label 0.9rem/550 in `ink-2`, ink when on. Focus puts the accent ring on the track. Used for Published/Draft in the editor bar.

### Navigation
- **Landing:** sticky blurred bar (85% canvas, 12px blur, hairline bottom) with the wordmark left and ghost "Sign in" + primary "Create yours" right; sign-in hides under 480px.
- **Workshop:** mobile is the same sticky bar with a horizontally scrolling list of 0.9rem muted links; from 1280px a sticky left column (wordmark, link list, then "Open your page" and "Log out" pinned to the bottom).
- **Editor bar:** sticky, bleeding to the column edges, 88% canvas with 10px blur; ghost "Back" left, the Published switch and a small primary "Save" (or "View live" / "Delete" / "Edit" on the read view) right.
- **Public page:** no nav; the footer is the wordmark, RSS and the theme toggle in `muted`, ink on hover. Owners see a one-line muted owner bar above the hero.
- **Theme toggle:** 2.25rem circle, white with hairline, sun/moon icons cross-fading with a 0.5s rotate-scale.

### Poster Index Row (signature)
The link, as an entry in an index rather than a button: a 3rem glyph disc (1rem radius, filled with `--brand`, inset white ring) holding the simple-icons brand path in white at 1.5rem (or a 1.35rem outward arrow for unknown hosts on the ultramarine fallback), the label in the index voice, the host in 0.8rem mono `muted`, and a 1.35rem outward arrow at the far right in `muted`. Rows sit on hairlines. On hover the row slides 0.35rem right over 320ms, the label takes a 2px underline, the disc rotates -6° and scales 1.06, and the arrow turns ink and nudges up-right 2px. No lift, no shadow. Hooks: `.b-link[data-id]` (the draft painter replaces or appends rows here).

### Poster Ledger (signature)
Work and Writing as ledgers: a Bricolage section heading and a mono count on the first line, then rows with an 8.5rem mono date gutter (`2023 – present`, `Aug 2026`) and a body of Bricolage title (`Role · Company` or the post title, underlined on hover), a `muted` location line, notes as a plain bulleted list in `ink-2`, tech chips, or the post excerpt in `ink-2` capped at 42rem. A job with no end date is `is-current`: its date turns `ok` at weight 500 with a 0.5rem pulsing dot before it — the one live signal on the page. Pagination, when needed, sits 1.25rem below in ghost buttons.

### Poster Photo
When attached: a 14rem square with 2rem corners, `object-fit: cover`, `lift-2`, right-aligned in the hero grid from 768px; below that an 8.5rem square with 1.75rem corners, centred above a centred name, handle and bio. Fetch-priority high with fixed 384px intrinsic size so the name never shifts.

### Live Preview + Drafts (workshop)
The phone iframe reloads 250ms after any Turbo submit or frame load (`preview_controller`); while it reloads the "Live" mono label's `ok` dot pulses at 900ms. While a link, work or profile form is being edited, `draft_controller` debounces 180ms and paints the unsaved values straight into the iframe: name and bio are written to `.page-name` / `.page-bio`; links and experiences are fetched from `/dashboard/drafts/{link,experience}`, which render the real public components (`LinksSectionComponent`, `ExperienceSectionComponent`) and are spliced into `.poster-links` / `.b-work` (or created after the hero / before `.b-writing` when the section did not exist). Leaving the form without submitting reloads the frame. Drafts carry `data-draft` so a re-paint replaces its predecessor.

### Editor
Lexxy themed to the tokens (`--lexxy-*` mapped to ink, muted, accent, canvas, fonts, 0.5rem radius, `lift` shadow, focus ring off). Inside the paper the editor has no chrome: a slim toolbar (92% white, 10px blur, hairline, 0.5rem radius, 2rem buttons in `muted` that go ink on hover) sticky at 3.6rem, then the text at 1.1rem/1.7 with the accent caret and a 4rem bottom runway; headings in Bricolage 650 (1.9 / 1.5 / 1.2rem), code and pre on `card-2` with hairlines, blockquotes with a 2px `line-2` rule, placeholder in `subtle`. Below, a hairline-topped mono help line (0.72rem, `subtle`, bold keys in `muted`) and the newsletter aside (white, 1.25rem radius) with either the send checkbox or the copy-link URL pill.

### Wordmark
"whoami" in Bricolage 700 at 1.2rem, -0.03em, preceded by the rotated ultramarine square; 1rem in footers.

### Flash
Fixed top-centre ink pill (1.25rem radius, max 34rem) with canvas text, a `ok` or `danger` status dot, a round dismiss button (70% → 100% opacity, 12% white on hover), `lift-2`, sliding in over 480ms and out over 320ms. Auto-dismisses after 4.5s (8s for alerts), pausing while hovered; a second flash stacks 3.25rem lower.

### Empty
Dashed `line-2` box, 1.25rem radius, centred muted text with a bold ink first line; the workshop's "Add link" / "Add experience" targets use the same dashed language.

## Do's and Don'ts

### Do:
- **Do** fill every glyph disc with the platform's brand colour (`--brand` from `link_brand`), keep the glyph white, and fall back to ultramarine for unknown hosts.
- **Do** keep the poster on the app's own canvas and ink; the only colour on it is a brand disc or the green current-job date.
- **Do** use ink (`button-primary`) for every primary action and keep the accent for links, focus, live state and the fallback disc.
- **Do** set anything that is a date, handle, host, URL or count in Geist Mono with tabular figures.
- **Do** let every poster section be exactly as tall as its content, and skip it entirely when it has no data.
- **Do** render the landing sample and every workshop draft through the real public components (`PublicProfile::*`) so the miniature and the preview are the page, not a picture of it.
- **Do** keep depth flat at rest; use `lift-2` only for floating frames, the toast and the photo.
- **Do** respect `prefers-reduced-motion` (all durations collapse to ~0) and keep the entrance stagger (640ms rise; 60 / 140 / 220 / 300 / 360ms delays) off in the preview iframe and the landing sample.
- **Do** define every colour in both the `:root` and `[data-theme="dark"]` blocks; dark keeps brand fills and lifts the accent text to `#8A8AFF`.

### Don't:
- **Don't** put saturated colour on the canvas, in nav chrome, in buttons or in poster type; colour belongs inside a disc or a dot.
- **Don't** render links as buttons, tiles or a centred stack on the public page; they are index rows on hairlines.
- **Don't** give a poster section a minimum height, a grid span or a card around it; there are no tiles, trays or cards on the poster.
- **Don't** use `button-accent` on product surfaces or fill a card with a state hue; states are text on a `-soft` tint, a dot, or the switch track.
- **Don't** introduce a fourth typeface or a system display face; names and headings are Bricolage, nothing else is.
- **Don't** set anything but the name at the 7rem display size, track body text tighter than -0.015em, or set display weights below 650.
- **Don't** add hard offset shadows, drop shadows at rest, hover lifts on the poster, or borders thicker than 1px (the editor blockquote rule at 2px is the one exception).
