# Mon3D fork notes (for maintainers)

Mon3D is SolidCraft (tangency-labs/solidcraft, Apache-2.0 / MIT code, LICENSE-BRAND for the UI
kit, look, theme and brand) with a Mongolian interface, its own name, year and mark, a news feed and
a per-user Windows installer. Forked 2026-11-16; remote `upstream`.

First released as **MonSolid 2026** (v0.43.0, 2026-11-16); renamed **Mon3D** the same day at the
owner's request (repo `Mandakha1/monsolid` → `Mandakha1/mon3d`, v0.43.1). The installer removes a
MonSolid install and moves its `MonSolid` settings folders to `Mon3D`. Local working copies keep
their old paths: `~/monsolid`, `~/monsolid-work`.

## What changed, and where

| Area | Change | Files |
|---|---|---|
| Name and year | `brand::NAME`, `brand::YEAR`, `brand::FULL_NAME` ("Mon3D 2026"): window title, About, installer. Next year: change `YEAR` and `FULL_NAME` only. | `crates/ui-egui/src/brand.rs`, `documents.rs`, `help.rs`, `apps/solidcraft/src/main.rs` |
| Executables | `mon3d`, `mon3d-cli` via `[[bin]]`; package names stay `solidcraft*` so upstream merges stay small | `apps/*/Cargo.toml` |
| Folders | `%LOCALAPPDATA%\Mon3D`, `~/Library/Application Support/Mon3D`, eframe storage `Mon3D` (never shares SolidCraft's settings or autosaves) | `crates/engine/src/recovery.rs`, `apps/solidcraft/src/main.rs` |
| MCP | server `mon3d` / "Mon3D"; `mcp setup` writes `mon3d` and `mon3d-live` entries | `crates/mcp/src/server.rs`, `crates/engine/src/agent_setup.rs` |
| Updates | repo `Mandakha1/mon3d`; `update::AUTOMATIC_CHECKS = true` (releases are published) | `crates/ui-egui/src/update.rs` |
| Bug reports | `Mandakha1/mon3d/issues` | `crates/ui-egui/src/issue_report.rs` |
| Mark | isometric cube in the Mongolian flag's colours (drawn in code) | `assets/icons/app/shared/source/app_icon.rs` |
| Mongolian | `assets/locales/mn.json` (complete, held to every English message), registered in `crates/ui-egui/src/i18n.rs` | glossary: `docs/mon3d/mn-3d-glossary.md` |
| Brand in messages | `SolidCraft` → `Mon3D` in every catalog's values (ids unchanged); `help.based_on` keeps the credit | `~/monsolid-work/tools/catalogs.py brand` |
| News | `crates/mon-news`: feed `news/feed.json` in Mandakha1/moncad, card + Windows toast, Help → News | `crates/ui-egui/src/lib.rs` (`news_tick`) |
| Windows installer | NSIS, per-user, Mongolian/English, registers the toast id `MonHydro.Mon3D` | `packaging/mon3d/` |

Unchanged on purpose: the `.sc` design format and its `solidcraft/N` tag (files stay compatible),
`SOLIDCRAFT_*` environment variables, the Linux app id, the web build, docs outside `docs/mon3d/`.

## Licence

The geometry code is MIT OR Apache-2.0. `crates/ui-kit`, `crates/look`, `crates/theme` and the brand
assets are under LICENSE-BRAND: distributing builds that contain them needs the SolidCraft
maintainers' written permission (section 3). The project owner decided on 2026-11-16 to distribute
Mon3D and keeps that permission. Every package ships LICENSE-MIT, LICENSE-APACHE, LICENSE-BRAND and
NOTICE, and About and the download page credit SolidCraft and Tangency Labs.

## Merging upstream

```bash
git fetch upstream && git merge upstream/main
python3 -I ~/monsolid-work/tools/catalogs.py brand   # new English messages get the name
cargo test -p solidcraft-ui-egui i18n                # mn.json must carry every new English message
```

New English messages must be added to `mn.json` (the complete-catalog test fails otherwise).
