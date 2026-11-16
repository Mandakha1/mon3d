# MonSolid fork notes (for maintainers)

MonSolid is SolidCraft (tangency-labs/solidcraft, Apache-2.0 / MIT code, LICENSE-BRAND for the UI
kit, look, theme and brand) with a Mongolian interface, its own name, year and mark, a news feed and
a per-user Windows installer. Forked 2026-11-16; remote `upstream`.

## What changed, and where

| Area | Change | Files |
|---|---|---|
| Name and year | `brand::NAME`, `brand::YEAR`, `brand::FULL_NAME` ("MonSolid 2026"): window title, About, installer. Next year: change `YEAR` and `FULL_NAME` only. | `crates/ui-egui/src/brand.rs`, `documents.rs`, `help.rs`, `apps/solidcraft/src/main.rs` |
| Executables | `monsolid`, `monsolid-cli` via `[[bin]]`; package names stay `solidcraft*` so upstream merges stay small | `apps/*/Cargo.toml` |
| Folders | `%LOCALAPPDATA%\MonSolid`, `~/Library/Application Support/MonSolid`, eframe storage `MonSolid` (never shares SolidCraft's settings or autosaves) | `crates/engine/src/recovery.rs`, `apps/solidcraft/src/main.rs` |
| MCP | server `monsolid` / "MonSolid"; `mcp setup` writes `monsolid` and `monsolid-live` entries | `crates/mcp/src/server.rs`, `crates/engine/src/agent_setup.rs` |
| Updates | repo `Mandakha1/monsolid`; `update::AUTOMATIC_CHECKS = false` until MonSolid publishes releases | `crates/ui-egui/src/update.rs` |
| Bug reports | `Mandakha1/monsolid/issues` | `crates/ui-egui/src/issue_report.rs` |
| Mark | isometric cube in the Mongolian flag's colours (drawn in code) | `assets/icons/app/shared/source/app_icon.rs` |
| Mongolian | `assets/locales/mn.json` (complete, held to every English message), registered in `crates/ui-egui/src/i18n.rs` | glossary: `docs/monsolid/mn-3d-glossary.md` |
| Brand in messages | `SolidCraft` → `MonSolid` in every catalog's values (ids unchanged); `help.based_on` keeps the credit | `~/monsolid-work/tools/catalogs.py brand` |
| News | `crates/mon-news`: feed `news/feed.json` in Mandakha1/moncad, card + Windows toast, Help → News | `crates/ui-egui/src/lib.rs` (`news_tick`) |
| Windows installer | NSIS, per-user, Mongolian/English, registers the toast id `MonHydro.MonSolid` | `packaging/monsolid/` |

Unchanged on purpose: the `.sc` design format and its `solidcraft/N` tag (files stay compatible),
`SOLIDCRAFT_*` environment variables, the Linux app id, the web build, docs outside `docs/monsolid/`.

## Licence

The geometry code is MIT OR Apache-2.0. `crates/ui-kit`, `crates/look`, `crates/theme` and the brand
assets are under LICENSE-BRAND: distributing builds that contain them needs the SolidCraft
maintainers' written permission (section 3). The project owner decided on 2026-11-16 to distribute
MonSolid and keeps that permission. Every package ships LICENSE-MIT, LICENSE-APACHE, LICENSE-BRAND and
NOTICE, and About and the download page credit SolidCraft and Tangency Labs.

## Merging upstream

```bash
git fetch upstream && git merge upstream/main
python3 -I ~/monsolid-work/tools/catalogs.py brand   # new English messages get the name
cargo test -p solidcraft-ui-egui i18n                # mn.json must carry every new English message
```

New English messages must be added to `mn.json` (the complete-catalog test fails otherwise).
