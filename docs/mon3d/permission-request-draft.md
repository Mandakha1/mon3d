# Draft: request to the SolidCraft maintainers (not sent)

To be posted, only after the owner approves it, as an issue at
https://github.com/tangency-labs/solidcraft/issues/new from the owner's GitHub account (Mandakha1).

---

**Title:** Permission request (LICENSE-BRAND §3): distributing Mon3D, a Mongolian edition of SolidCraft

Hello SolidCraft maintainers,

I teach CAD to engineers in Mongolia (https://cad.monhydro.com). We would like to offer SolidCraft to
Mongolian engineers with a complete Mongolian interface, and we are asking for your written
permission under section 3 of LICENSE-BRAND before we distribute anything.

What we have done (not distributed, local builds only):

- A complete Mongolian (Cyrillic) catalog, `assets/locales/mn.json`: every one of the 6,770 English
  messages, checked for placeholders, ellipses and line breaks, with a CAD glossary. **We are happy
  to contribute it upstream as a pull request under MIT OR Apache-2.0, whatever you decide below.**
- A fork named **Mon3D 2026**: its own name, year and app mark (a cube in the colours of the
  Mongolian flag), its own settings folders, update channel, MCP server name and issue tracker, so
  it never collides with an installed SolidCraft; a per-user Windows installer; and a small opt-in
  news feed (course announcements, no tracking).
- About and the installer credit SolidCraft and Tangency Labs; NOTICE, LICENSE-MIT, LICENSE-APACHE
  and LICENSE-BRAND are shipped unchanged.

What we ask permission for:

1. Distributing Mon3D builds (Windows installer, later macOS) free of charge to the public,
   containing the UI kit, look and theme (crates/ui-kit, crates/look, crates/theme) unchanged
   apart from the name.
2. Showing course announcements and occasional sponsor notices (clearly labelled "Ad") from our own
   feed inside Mon3D. If you would rather we did not, we will leave that out.

We will follow any conditions you set (for example a visible "based on SolidCraft" line, a different
look, or keeping releases in sync with yours). If you prefer that we only contribute the Mongolian
translation and point people to the official SolidCraft download, we will do that instead.

Thank you for SolidCraft.

Mandakha (github.com/Mandakha1)
