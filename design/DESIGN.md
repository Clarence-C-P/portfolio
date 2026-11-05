# Design direction (P01-T03)

**Idea:** the resume is the design. The site borrows the look of a well-made printed CV: clean margins, section names in a left rail, content on the right. The one memorable element is a **highlighter**: the yellow accent marks what is picked (shown on site, chosen for a resume version) and is never decoration.

Live reference: open `design/styleguide.html` with Live Server.
All values live in `css/base.css`.

## Colour
| Token | Hex | Use |
|---|---|---|
| `--paper` | `#ffffff` | page and resume background |
| `--wash` | `#f3f5f7` | editor background, desk behind the Letter preview |
| `--ink` | `#18212f` | main text, primary buttons, focus outline |
| `--ink-soft` | `#4a5568` | dates, companies, secondary text |
| `--rule` | `#d9dee5` | thin lines, input borders |
| `--highlight` | `#f6e05e` | **only** as a background behind ink text |
| `--danger` | `#b42318` | delete, errors |

The resume uses ink, ink-soft and rule only (yellow prints badly).

## Type
- **Schibsted Grotesk:** name, headings, buttons, editor UI.
- **Source Serif 4:** reading text on the public page and the resume.
- Scale 1.25: 13 / 16 / 17 (body) / 20 / 25 / 31 px; the name is fluid, 44 to 88 px.
- Reading text max 68 characters per line.

## Rules
- Rows and lines, not grids of identical rounded cards.
- Radius 4px, buttons and inputs only.
- Left-aligned everywhere.
- Motion only in response to a click (open form, save).
- Button labels say what happens: "Save changes", "Add education", "Download PDF".
- Keyboard focus is always visible (2px ink outline).

## Wireframes
```
PUBLIC PAGE (index.html)                 EDITOR (admin/index.html)
┌──────────────────────────────────┐     ┌──────────┬──────────────────────┐
│ REN_DC.DEV            (big name) │     │ Profile  │ Education      + Add │
│ Web developer, Philippines       │     │ Educ.  ◀ │ ┌──────────────────┐ │
│ [photo]  short summary           │     │ Exper.   │ │▓BS IT, 2026     ✎│ │  ▓ = highlight:
│          GitHub  LinkedIn  Email │     │ Projects │ │ Senior High     ✎│ │    shown on site
├──────────┬───────────────────────┤     │ Skills   │ └──────────────────┘ │
│ Projects │ Portfolio site  [img] │     │ Certs    │ form opens here      │
├──────────┼───────────────────────┤     │ Referees │ on add / edit        │
│ Experience│ Role, Company, dates │     │ Resumes  │                      │
│ Skills   │                       │     └──────────┴──────────────────────┘
└──────────┴───────────────────────┘      phone: section list becomes a
 phone: the rail stacks above content     dropdown at the top

RESUME A, single column (Letter)         RESUME B, two column (week of 9 Nov)
┌────────────────────────┐               ┌────────┬───────────────┐
│ NAME                   │               │ photo  │ NAME          │
│ headline, contact      │               │ contact│ Summary       │
│────────────────────────│               │ Skills │ Experience    │
│ Summary                │               │ Certs  │ Projects      │
│ Experience             │               │        │ Education     │
│ Projects, Education    │               │        │               │
└────────────────────────┘               └────────┴───────────────┘
```

## Notes
- DOCX export (T17): Word will only show these fonts if they are installed; fall back to Georgia (serif) and Arial (sans) in docx.js.
- Canva (T18): PDF import keeps the layout; if a font is missing in Canva, pick the closest match there.
