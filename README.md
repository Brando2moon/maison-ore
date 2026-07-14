# Handoff: Maison Oré — Luxury Multivendor Marketplace

## Overview

Maison Oré is a curated luxury goods marketplace where independent ateliers and heritage houses sell handmade objects (ceramics, textiles, objets, furniture). The design consists of **four connected pages**:

1. **Home** (`index.html`) — Landing page with hero, featured category, vendor spotlight, editorial block, and vendor-recruitment CTA.
2. **Shop** (`shop.html`) — Product browsing with a **split layout**: filterable product grid on the left, live product detail view on the right. Clicking a product card updates the detail pane.
3. **Vendor Signup** (`sell.html`) — Single-step vendor application with intro/benefits sidebar and a form covering contact info, business info, work description, and agreements.
4. **Dashboard** (`dashboard.html`) — Combined admin/vendor dashboard with a role toggle in the sidebar. Includes stat cards, revenue chart (SVG), top products list, and recent orders table.

The aesthetic direction is **modern boutique** — clean sans-serif, gallery-like whitespace, thin gold hairline accents against a warm-white paper background with deep-navy text and sky-blue primary accents.

---

## About the Design Files

The files in this bundle are **design references created in HTML** — they are prototypes demonstrating the intended look, feel, layout, and interactions of the product. **They are not production code to copy verbatim.**

The task for the developer is to **recreate these HTML designs inside the target codebase's existing environment** — using its established framework (React / Vue / SvelteKit / Next.js / etc.), routing, component library, state management, and styling conventions. If no environment exists yet, choose the most appropriate stack for a marketplace app and implement the designs there.

Treat these files as **source of truth for visual specification and interaction behavior**, but not as source of truth for code architecture.

---

## Fidelity

**High-fidelity (hifi).** Every screen is a pixel-considered mockup with final colors, typography, spacing, and interactions. The developer should recreate the UI pixel-perfectly using the target codebase's libraries and patterns.

Product imagery is intentionally left as **striped SVG placeholders** labeled `product shot`, `hero — featured piece`, etc. — real photography will be dropped in later by the client. The placeholder styling is defined in `shared.css` under `.placeholder`.

---

## Design Tokens

All tokens are defined as CSS custom properties in `shared.css` under `:root`. Port them to whatever token system the target codebase uses (Tailwind config, MUI theme, Chakra tokens, CSS variables, etc.).

### Colors

| Token | Hex | Usage |
|---|---|---|
| `--paper` | `#FAFAF7` | Page background, card surfaces |
| `--cream` | `#F3EFE7` | Secondary sections, placeholder base, hover backgrounds |
| `--ink` | `#0B1F3A` | Body text, primary buttons, dark surfaces (footer, dashboard nav) |
| `--ink-70` | `rgba(11,31,58,0.7)` | Muted text |
| `--ink-50` | `rgba(11,31,58,0.5)` | Dim text, meta labels |
| `--ink-30` | `rgba(11,31,58,0.3)` | Placeholder text, disabled |
| `--ink-12` | `rgba(11,31,58,0.12)` | Hairline borders, dividers |
| `--ink-06` | `rgba(11,31,58,0.06)` | Softest borders (nav bottom) |
| `--sky` | `#7CB2D6` | Primary accent — chart line, CTA (`btn-sky`), stat delta pills |
| `--sky-deep` | `#4A8BB5` | Sky on hover, sky text on tint backgrounds |
| `--sky-tint` | `#E8F1F7` | Sky background tint (avatars, status pills) |
| `--gold` | `#B8894A` | Metallic accent — hairlines, icons, eyebrows, hover borders |
| `--gold-soft` | `#D4B584` | Gold on dark backgrounds (footer brand mark, become-vendor stats) |
| `--gold-tint` | `#F7F1E6` | Gold background tint (badges, status pills) |

Gold is **accent-only** — never a fill for major surfaces. It appears as:
- 1px underlines beneath navigation active states and eyebrow links
- Icon strokes on trust badges
- Small filled shapes inside outlined brand marks
- Left-borders on quote/promise blocks
- Focus underlines on form inputs

### Typography

**Font family:** `Inter` (Google Fonts, weights 300 / 400 / 500 / 600) with `JetBrains Mono` (400 / 500) for monospace labels (dates, ref numbers, chart axes, placeholder captions).

Font feature settings on `body`: `"ss01", "cv11"` for Inter's alternate stylistic sets.

| Class | Size (clamp) | Weight | Letter-spacing | Line-height |
|---|---|---|---|---|
| `.display` | `clamp(48px, 7vw, 104px)` | 300 | -0.035em | 0.98 |
| `.h1` | `clamp(36px, 4.5vw, 64px)` | 300 | -0.028em | 1.05 |
| `.h2` | `clamp(28px, 3.2vw, 44px)` | 300 | -0.022em | 1.05 |
| `.h3` | `22px` | 400 | -0.015em | 1.05 |
| `.h4` | `16px` | 500 | -0.005em | 1.05 |
| body | `15px` | 400 | 0 | 1.55 |
| `.eyebrow` | `11px` | 500 | 0.22em UPPERCASE | — |
| `.mono` | `11px` | 400 | 0.04em | — |

**Convention:** Headings use light weight (300) with tight negative letter-spacing. Body copy is regular (400). Eyebrows/labels are always uppercase, medium weight, wide letter-spacing, and colored in either gold or `--ink-70`.

### Spacing

| Token | Value | Usage |
|---|---|---|
| `--gutter` | `clamp(20px, 4vw, 56px)` | Horizontal container padding |
| `--stack-lg` | `96px` | Major vertical section rhythm |
| `--stack-md` | `56px` | Medium vertical rhythm |
| `--stack-sm` | `24px` | Small vertical rhythm |

Container max-widths: `1440px` (`.container`), `1600px` (`.container-wide`).

### Border radius

**Effectively zero.** The design is intentionally rectilinear — a gallery/print aesthetic. No border-radius above 4px anywhere except:
- Circular dots inside status pills (`border-radius: 50%`)
- Cart badge (small pill)
- Circular avatar option in vendor cards (not currently used, but tokenizable)

### Shadows

**None used.** Depth comes from hairline borders (`--ink-12`), color contrast, and thin gold accents. Do not add drop-shadows when porting.

### Other

- Buttons: `padding: 14px 28px`, font-size `12px`, letter-spacing `0.14em`, UPPERCASE, `1px` border, all-caps text.
- Transitions: `0.2s ease` (small state changes), `0.24s ease` (button/card hover), `0.3s ease` (image transforms).
- Sticky nav: `backdrop-filter: saturate(180%) blur(12px)` on 92%-opacity paper background.

---

## Global Components

Reused across all four pages, defined in `shared.css`:

### Navigation (`.nav`)
Sticky top bar (68px tall). Three-column grid: **brand left**, **nav links center**, **actions right**.
- Brand: 22×22 square outlined in gold with a 6×6 gold square inside, followed by uppercase "Maison Oré" wordmark with `0.12em` tracking.
- Nav links: 13px `--ink-70`, gain `--ink` on hover, gain gold 1px underline (`::after`) when `.active`.
- Actions: 32×32 icon buttons (search, account, cart). SVG icons at 18×18, stroke-width `1.4`. Icons turn gold on hover.
- Cart shows a small gold badge with a numeric count.

### Footer (`.footer`)
Deep navy background, 80px top padding. Four-column grid: brand + description, then three link columns (Shop / Vendors / Maison). Brand mark uses `--gold-soft` on this dark surface. Column headers are gold eyebrows. Links transition to `--paper` on hover. Bottom row: copyright + legal links in `rgba(paper, 0.5)`.

### Placeholder image (`.placeholder`)
Diagonal-stripe SVG background (135deg repeating linear-gradient over `--cream`), with a 1px inset hairline (`::before`) and a centered monospace label. **Replace all `.placeholder` blocks with real `<img>` tags when photography is delivered.**

### Buttons

| Class | Look |
|---|---|
| `.btn-primary` | Solid `--ink` background, `--paper` text. Hover: transparent bg, `--ink` text, gold border. |
| `.btn-ghost` | Transparent bg, `--ink` text, `--ink-12` border. Hover: gold border + gold text. |
| `.btn-sky` | Solid `--sky` bg, `--ink` text. Hover: `--sky-deep` bg, `--paper` text. Used for "Apply to sell". |
| `.btn-lg` | Adds `18px 36px` padding. |
| `.btn-sm` | Reduces to `10px 18px`. |

All buttons contain optional `<span class="arrow">→</span>` which translates `+4px` on hover via `.btn:hover .arrow`.

### Announcement bar

**REMOVED per client request.** The top navy strip previously above the nav is no longer part of the design. Do not implement it.

---

## Screens

### 1. Home (`index.html`)

**Purpose:** Introduce the marketplace, showcase featured category, spotlight vendors, and funnel makers to the vendor signup.

**Sections (top to bottom):**

#### 1.1 Nav (see Global Components)

#### 1.2 Hero (`.hero`)
Two-column grid, `1fr : 1.05fr`, min-height 620px, gap 64px.
- **Left (`.hero-copy`)** — vertical flex, space-between:
  - Top block: gold eyebrow "Fall Edit — Collection 07" → `.display` H1 with `<em>` word colored gold → 440px-max lede paragraph → button row (`.btn-primary` "Explore Collection" + `.btn-ghost` "The Fall Edit").
  - Bottom block: three-stat row (`.hero-meta`) separated by top hairline. Each stat: 28px numeric value + uppercase caption.
- **Right (`.hero-visual`)** — grid rows `2fr 1fr`, gap 16px:
  - Full-width `.placeholder` labeled "Hero — Featured Piece" (min-height 380px).
  - Two-column row of smaller placeholders labeled "Detail Shot" and "In Situ".
  - Absolute-positioned `.hero-badge` in top-left: paper bg, gold 1px border, gold uppercase text.

#### 1.3 Trusted Houses strip (`.houses`)
Full-bleed cream background, 32px vertical padding. Flex-row with gold-uppercase "Trusted by houses in —" label followed by 6 city names in `--ink-70` at 18px.

#### 1.4 Featured Category (`.featured`)
`.section-head`: two-column flex — eyebrow + `.h1` + subhead on left; gold-underlined "View all X pieces" link on right.
Grid `1.35fr : 1fr`, gap 24px:
- **Left `.featured-large`**: min-height 620px placeholder with absolute-positioned `.overlay` at bottom (28px inset from sides, 32px from bottom). Overlay has gold top-border, eyebrow "Atelier · Location", `.h3` product name, hairline divider, then meta row with edition info + price.
- **Right `.featured-side`**: grid rows `1fr 1fr`, gap 24px. Each `.featured-card` is a two-column split (image | body); body has eyebrow, `.h3` name, then footer row with availability + price.

#### 1.5 Editorial (`.editorial`)
Two-column grid `1fr : 1.4fr`, gap 72px, vertically centered.
- **Left**: eyebrow "The Standard" → `.h1` → two paragraphs → `.btn-ghost` "Read our vendor standards".
- **Right**: min-height 540px placeholder with absolute `.editorial-quote` overlay at bottom. Quote has left gold border, 18px quote text, uppercase attribution.

#### 1.6 Featured Ateliers (`.vendors`)
Full-bleed cream background. Section head (eyebrow + `.h1` + "All 240 vendors →" link).
Four-column grid of `.vendor-card`. Each card: 56×56 monogram avatar (alternates sky-tint bg + gold-tint bg with matching text color), name, uppercase location, hairline-separated stats row (pieces count + star rating).
Card hover: `border-color: gold`, `transform: translateY(-3px)`.

#### 1.7 Become a Vendor CTA (`.become-vendor`)
Full-bleed navy background. Subtle sky-blue linear-gradient overlay from top-right (`::before`).
Two-column grid `1.2fr : 1fr`, gap 80px.
- **Left**: gold eyebrow → paper-white `.h1` → paragraph in `rgba(paper, 0.7)` → `.btn-sky` "Apply to sell".
- **Right**: 2×2 grid of `.bv-stat`. Each stat: 48px gold-soft number + uppercase caption in `rgba(paper, 0.6)`, separated by 1px `rgba(paper, 0.15)` top border.

#### 1.8 Footer (see Global Components)

---

### 2. Shop (`shop.html`)

**Purpose:** Browse products with immediate detail visibility — no page navigation for detail viewing.

#### 2.1 Nav (see Global Components)

#### 2.2 Shop Header (`.shop-header`)
- Breadcrumb: uppercase links separated by gold `/` characters.
- Title row: eyebrow "The Ceramics Edit" → `.h1` "Handmade Vessels & Objects" → 560px-max subhead. Right side: piece count with gold-highlighted number.

#### 2.3 Toolbar
Below shop-header, above split layout. Flex-row space-between.
- **Left**: `.filters` — 6 `.filter-chip` buttons. Active chip: navy bg, paper text. Inactive: paper bg, `--ink-70` text, `--ink-12` border. Hover: gold border + gold text.
- **Right**: "Sort by" label + `<select>` styled as a hairline-bottom pill (Featured / Price Low-High / Price High-Low / Recently Added).

#### 2.4 Split Layout (`.shop-layout`)
Two-column grid `1fr : 1.2fr`, right column contains the detail view.

**Left column (`.listing`)** — sticky, scrollable to `calc(100vh - 68px)`. Contains `.products-grid`: two-column grid of `.product-card`.
Each product card:
- `.thumb` — aspect-ratio 4:5, `.placeholder` inside.
- Optional top-left `.badge` (gold border, gold text, "Signed" etc.).
- Top-right `.fav` heart button (28×28, gains gold color on hover).
- Below thumb: `.info` block with gold uppercase vendor name, 14px product name, 13px tabular price.
- Selected state: `.selected` adds `2px solid gold` outline via `.thumb::after`.
- Hover: `.thumb` translates -2px.

**Right column (`.detail`)** — 40px left padding, grid `1.1fr : 1fr`, gap 40px.
- **`.detail-gallery`**: main 4:5 placeholder + 4-thumbnail row below. Active thumbnail has 1px gold outline (`outline-offset: -1px`). Clicking thumbnails toggles the active state (visual only in mock).
- **`.detail-info`** (sticky, top 100px):
  - `.detail-vendor` row: 36×36 avatar (sky-tint bg) + vendor name/location + gold-underlined "View shop →". Bottom hairline.
  - Gold eyebrow (category) → 32px `detail-title`.
  - `.detail-price-row`: hairlines top+bottom, 24px vertical padding. Left: 32px tabular price. Right: uppercase availability with a `--sky-deep` dot indicator.
  - Description paragraph (14px, `--ink-70`, line-height 1.75).
  - `.detail-specs`: five `.spec-row` rows separated by `--ink-06` hairlines. Each row: uppercase key (11px, `--ink-50`) + value (13px `--ink`, tabular).
  - `.detail-actions`: flex row — primary "Add to cart" (flex:1) + ghost "Save".
  - `.detail-badges`: three `.badge-line` chips (gold-tint bg, gold text, gold-stroke SVG icons) — "Verified at source", "White-glove ship", "14-day return".

**Interaction:** Clicking any `.product-card` calls `renderDetail(id)` which updates all text nodes in the detail panel from the `products` array. The selected card gets `.selected` class. Filter chips call `render()` which re-populates the grid based on `activeFilter` + updates the total count.

#### 2.5 Footer (see Global Components)

**Product data model:** See `products` array at the bottom of `shop.html`:
```js
{
  id, vendor, vendorInit, loc, region, cat, name, price, avail, badge, tags,
  desc, specs: [[key, value], ...]
}
```
Filter values: `all | japan | europe | americas | new | signed`. `tags` array holds `new` / `signed`; `region` is a single value.

---

### 3. Vendor Signup (`sell.html`)

**Purpose:** Convert a maker/atelier into a submitted vendor application. Single-step form (no wizard).

#### 3.1 Nav (see Global Components)
Right side replaces cart with "Vendor Login →" text link.

#### 3.2 Hero (`.sell-hero`)
Two-column grid `1.1fr : 1fr`, gap 80px, aligned to end.
- **Left**: eyebrow → `.display` title (clamped to 40–76px) → 520px-max lede paragraph.
- **Right (`.sell-hero-side`)**: three stacked `.promise` blocks. Each: cream bg, gold `2px` left border, 20px 24px padding. Contains uppercase gold key + 15px value line.

#### 3.3 Body (`.sell-body` → `.sell-grid`)
Two-column grid `1fr : 1.5fr`, gap 80px.

**Left aside (`.sell-side`)** — sticky at top 100px.
- Eyebrow "The Process" → `.h2` → intro paragraph.
- `.side-benefits`: three `.side-benefit` rows, each `40px 1fr` grid — monospace "01/02/03" number in gold + heading (`h4`) + description. Hairlines top & bottom of each row.

**Right form card (`.form-card`)** — paper background, 1px ink-12 border, 48px padding.
Decorative gold corner accents via `::before` (40px horizontal) and `::after` (40px vertical) on top-left corner.

**Form head:**
- Uppercase step label in gold: "Vendor Application · 2027 Intake"
- 24px H3 "Tell us about you and your work"
- Note about gold `✦` marking required fields.

**Form sections** (each has uppercase section title with bottom hairline):

**01 — About you:**
- Row: First name + Last name (both required).
- Row: Email (required) + Phone (optional).

**02 — Your house:**
- Full-width: Business name (required).
- Row: City + Country (both required; country is `<select>` with Norway/Japan/France/Italy/Morocco/USA/Mexico/Other).
- Full-width: Website URL (required) with hint text.

**03 — Your work:**
- Full-width: Primary category — **radio group** rendered as 3-column grid of 6 pill-style radios (Ceramics / Textiles / Objets / Furniture / Lighting / Jewelry). Hidden native input; custom `.radio-dot` circle fills with gold when checked; parent gets cream bg + ink border.
- Row: Years practicing + Est. monthly output (both `<select>`, both required).
- Full-width: Textarea "Tell us about your work" (required, min-height 100px, vertical resize).

**04 — Agreement:**
- Three `.check-row` items with clickable custom `.check` boxes (18×18, ink bg + gold-soft checkmark when `.checked`). Default state: first two pre-checked, third unchecked.
- Labels are 13px `--ink-70` with gold-underlined links.

**Form footer:**
- Left: 12px `--ink-50` note "By submitting, you agree to be contacted..."
- Right: `.btn-primary.btn-lg` "Submit Application →".

**Field styling:**
- All `<input>` / `<select>` / `<textarea>` are borderless except a 1px `--ink-12` bottom border.
- Focus: bottom border becomes gold, no ring/glow.
- Placeholder text: `--ink-30`.
- Labels: 11px uppercase `--ink-70`, `.req` asterisk in gold.

**Interactions:**
- Clicking any `.check` toggles `.checked` class.
- On form submit (`onsubmit="handleSubmit()"`): hide `#formCard`, show `#success` panel, smooth-scroll to it.
- Success panel: 64×64 gold-outlined checkmark → eyebrow "Application Received" → 32px H3 → paragraph → monospace reference number in a gold-outlined cream pill (`REF · MO-27-INTAKE-0247`) → "Return home" ghost button.

**No real backend** — this is a mock. Wire the submit handler to your API in production.

#### 3.4 Footer (see Global Components)

---

### 4. Dashboard (`dashboard.html`)

**Purpose:** Manage vendor storefront and platform operations. **Includes a role toggle** — same layout serves both vendor and admin views with different data and copy.

**Body background:** `--cream` (different from other pages).

#### 4.1 Layout (`.dash-shell`)
`grid-template-columns: 260px 1fr`. Full-height.

#### 4.2 Sidebar (`.sidebar`)
Paper background, sticky at top, 100vh height, right hairline border, 28px 24px padding. Vertical flex column.

**Sidebar contents (top → bottom):**

1. **Brand row** — same brand mark + wordmark as nav, with bottom hairline separator.

2. **Role Toggle (`.role-toggle`)** — flex row inside a cream-bordered pill, 4px inner padding. Two `.role-btn` buttons: **Vendor** and **Admin**, each with a small icon. Active button: paper bg + gold 1px border. Clicking either calls `setRole('vendor' | 'admin')` which:
   - Updates `document.body.dataset.role`
   - Persists to `localStorage` key `mo_role`
   - Swaps: page title / eyebrow, stat card values, orders table content, user identity in sidebar footer, CTA label
   - Toggles `.admin-only` / `.vendor-only` visibility (CSS: `body[data-role="admin"] .admin-only { display: block; }` and vice versa)
   - Re-renders the orders table (admin variant adds a "Vendor" column)

3. **Nav sections** — each has an uppercase gray section title and a list of `<a>` items:
   - **Overview** (both roles): Dashboard (active by default) / Orders (with gold count badge "7") / Products / Payouts
   - **Studio** (vendor only): Storefront / Messages (badge "3")
   - **Platform** (admin only): Vendors (badge "4") / Approvals / Analytics
   - **Account** (both): Settings / "Back to store" (links to `index.html`)

   Nav item styling: 10px 12px padding, 13px font, 16×16 icons (stroke-width 1.4). Hover: cream bg + ink text. Active: cream bg + ink text + `--gold` `2px` left border.

4. **Sidebar user** (`.sidebar-user`) — bottom-anchored via `margin-top: auto`. Top hairline. 36×36 avatar (sky-tint) + name (13px 500) + role (10px gold uppercase). Vendor: "Ines Halden · Vendor · Studio Halden · SH". Admin: "Marcus Chen · Admin · Curation Team · MC".

#### 4.3 Main (`.main`)
Cream background, 28px 40px 40px padding.

**Topbar (`.topbar`)** — flex space-between, bottom hairline.
- Left: role-dependent eyebrow ("Vendor Dashboard" / "Admin Dashboard") + 28px H1 ("Good afternoon, Ines" / "Platform overview").
- Right: `.date-picker` (paper bg, 1px ink-12 border, calendar icon + "Last 30 days") + `.btn-primary.btn-sm` (role-dependent CTA: "List new piece" / "Review applications").

**Stat cards (`.stat-grid`)** — 4-column grid of `.stat-card`. Each:
- Paper bg, 1px ink-12 border, 24px padding.
- 10px uppercase gray label.
- 32px `font-weight: 300` tabular value.
- Colored delta pill: `.delta` is sky-tint bg + sky-deep text (up); `.delta.down` is gold-tint bg + gold text.
- Absolute-positioned 80×30 SVG sparkline in bottom-right. Sky sparklines for revenue/avg, gold for orders/payout.

Vendor values: `$24,840` / `142` / `$174.93` / `$3,120`. Admin values: `$1.24M` / `3,847` / `$322.14` / `240 vendors`.

**Widget grid (`.widget-grid`)** — 2-column `2fr : 1fr`, gap 16px.

**Left widget — Revenue Chart:**
- Widget head: eyebrow "Revenue Overview" + H2 + gold-underlined "Full report →" link.
- Legend row: two color-dot legends (sky = Revenue, gold = Orders) with matching tabular values.
- `.chart` — full-width 700×260 SVG with `preserveAspectRatio="none"`. Contents:
  - Four horizontal grid lines at Y=40/100/160/220, stroked `rgba(ink, 0.06)`.
  - Monospace Y-axis labels: `$30K / $22K / $14K / $6K`.
  - Sky-filled area path with 15%-opacity sky fill.
  - Sky solid line (2px, round caps) with circular anchor points on 5 dates.
  - Gold dashed comparison line (1.5px, `stroke-dasharray: 3,3`).
  - **Highlighted data point:** gold 5px circle at (550, 60) with a gold dashed vertical drop line to the axis.
  - **Tooltip** at `translate(490, 20)`: navy fill, gold border, monospace uppercase date ("JUN 24") + inter value ("$2,840 · 18 ord.") in paper.
  - Monospace X-axis: JUN 01 / JUN 08 / JUN 15 / JUN 22 / JUN 30.

**Right widget — Top Products:**
- Widget head: eyebrow "Top Products" + H2 "Best sellers, 30 days" + "All →" link.
- `.top-list` of 5 `.top-item` rows: `24px 40px 1fr auto` grid. Contents: gold monospace rank ("01"..."05"), 40×40 stripe thumb, name + meta (product name + variant), tabular right-aligned value with small uppercase "N sold" sub-line.

**Bottom widget — Recent Orders (`.orders-widget`)** — spans full width (`grid-column: 1 / -1`).
- Widget head: eyebrow "Recent Orders" + H2 (role-dependent title, e.g. "7 orders need your attention") + "View all orders →" link.
- `.orders-table` — full-width table.
  - `<th>`: cream bg, 10px uppercase gray labels with bottom hairline.
  - Columns: Order (monospace ID) | Customer (avatar + name + email) | *(Admin only)* Vendor | Item | Amount | Status | Action.
  - Row hover: sky-tint 4% background wash.
  - Status pills (`.status`): color-coded outlined pills with a 5px dot. Variants: `paid` (sky), `pending` (gold), `shipped` (ink-30 muted), `review` (ink-30 muted paper).
  - Action column: gold-underline-on-hover "View →" link.

Vendor sees 7 orders (their own). Admin sees 8 orders (all vendors) with the extra Vendor column visible.

**localStorage persistence:** `mo_role` key. On page load, `setRole(savedRole || 'vendor')` is invoked so the last-selected role sticks.

#### 4.4 No page footer on the dashboard (intentional — this is an app view, not a marketing page).

---

## Interactions & Behavior — Summary

| Screen | Behavior |
|---|---|
| Global nav | Sticky. Icon buttons hover to gold. Cart icon has a numeric badge. |
| Global buttons | Ghost/primary swap borders/backgrounds on hover; arrow spans slide +4px. |
| Home hero | Static. No animation on scroll. |
| Home vendor cards | Hover: gold border + `translateY(-3px)`. |
| Shop filter chips | Click to change active. `all` includes everything; region chips filter by `p.region`; `new`/`signed` filter by `p.tags`. |
| Shop product card | Click sets `selectedId`, calls `renderDetail()`, marks `.selected`. |
| Shop detail thumbnails | Click toggles `.active` class (visual only in mock — no real gallery swap since placeholders are identical). |
| Sell form checkboxes | Click toggles `.checked` class. |
| Sell form submit | Prevent default → hide form, show success panel, smooth-scroll. |
| Dashboard role toggle | Click swaps: body attribute, stats, orders, user identity, CTAs. Persists via localStorage. |
| Dashboard sidebar | No submenu behavior — flat list. |

**No dark mode**, no responsive breakpoints below tablet in scope (basic mobile stack breakpoints exist but the design is desktop-first).

**No animations beyond**: 0.2–0.3s CSS transitions on color, transform, border-color, and opacity. No scroll-triggered animations, no page transitions.

---

## State Management

For the developer's target codebase, the minimum state model:

**Global:**
- `cartCount` (number, displayed in nav badge)
- `currentUser` (name, avatar initials, role: `vendor | admin | guest`)

**Shop page:**
- `activeFilter: 'all' | 'japan' | 'europe' | 'americas' | 'new' | 'signed'`
- `sortOrder: 'featured' | 'price-asc' | 'price-desc' | 'recent'`
- `selectedProductId: number`
- `favorites: Set<number>` (heart-icon persistence)

**Vendor Signup:**
- All form fields (first name, last name, email, phone, business, city, country, website, category, years, output, description, agreement checkboxes)
- `submitted: boolean` (toggles success panel)

**Dashboard:**
- `role: 'vendor' | 'admin'` — persists to localStorage
- `dateRange: string` — currently static "Last 30 days"
- Server-fetched: stats, chart data (per role), top products, orders (per role)

---

## Data Fetching Requirements

The mock uses static in-file arrays. Production endpoints should provide:

**Public:**
- `GET /api/products?filter=&sort=&page=` → list of products for shop page
- `GET /api/products/:id` → product detail
- `GET /api/vendors/featured` → home page vendor spotlights
- `POST /api/vendor-applications` → sell.html form submission

**Authenticated (vendor):**
- `GET /api/vendor/stats?range=30d` → revenue, orders, avg, payout pending
- `GET /api/vendor/revenue-chart?range=30d` → chart series
- `GET /api/vendor/top-products?range=30d` → top 5
- `GET /api/vendor/orders?limit=7` → recent orders

**Authenticated (admin):**
- `GET /api/admin/stats?range=30d` → platform-wide metrics
- `GET /api/admin/revenue-chart?range=30d`
- `GET /api/admin/top-products?range=30d`
- `GET /api/admin/orders?limit=8` → cross-vendor orders

---

## Assets

**No binary assets shipped.** All imagery is placeholder — replace `.placeholder` blocks with real `<img>` tags backed by CDN URLs when photography arrives.

**Fonts (external, load via Google Fonts):**
- Inter — weights 300, 400, 500, 600
- JetBrains Mono — weights 400, 500

**Icons:** All icons are inline SVGs (Feather-style outline, stroke-width 1.4, currentColor stroke). Consider replacing with Lucide/Feather/Heroicons Outline in the target codebase for consistency. Icons used:
- Search, User, Cart (nav)
- Shield, Truck, Return (product trust badges)
- Grid/Dashboard, Bag, Shield, Chart, User, Message, Users, Zap, Clock, Settings, Arrow-Left (dashboard sidebar)
- Calendar (date picker)
- Checkmark (form success)

---

## Files

Copies of the source design files are included in this folder:

| File | Purpose |
|---|---|
| `index.html` | Home page |
| `shop.html` | Shop split-view (listing + detail) |
| `sell.html` | Vendor signup form |
| `dashboard.html` | Vendor/Admin dashboard with role toggle |
| `shared.css` | Design tokens, global components (nav, footer, buttons, placeholder), utility classes |

Load order in each HTML file: Google Fonts stylesheet → `shared.css` → inline `<style>` block for page-specific rules → body content → inline `<script>` (for shop filtering, sell form, dashboard role toggle).

Recommended porting approach:
1. Port `shared.css` tokens to the target framework's theme system first.
2. Build the shared Nav and Footer components.
3. Build shared primitives (`Button`, `PlaceholderImage`, `Chip`, `StatusPill`, `Eyebrow`).
4. Build page-specific components section-by-section, following the section breakdowns above.
5. Wire up the interactions (filter, detail selection, role toggle, form submission) to real data / API endpoints.
