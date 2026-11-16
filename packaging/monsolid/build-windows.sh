#!/usr/bin/env bash
# Build the MonSolid Windows x64 installer and portable zip from macOS or Linux.
#
#   brew install mingw-w64 makensis         # or apt install mingw-w64 nsis
#   rustup target add x86_64-pc-windows-gnu
#   packaging/monsolid/build-windows.sh     # → dist/monsolid-<year>-<ver>-windows-x64-setup.exe, -portable.zip
#
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
TARGET="${TARGET:-x86_64-pc-windows-gnu}"
VERSION="$(sed -n 's/^version = "\(.*\)"/\1/p' Cargo.toml | head -1)"
YEAR="$(sed -n 's/^pub const YEAR: &str = "\(.*\)";/\1/p' crates/ui-egui/src/brand.rs)"
DIST="$ROOT/dist"
# makensis crashes (std::bad_alloc) under the C locale on macOS, hence LC_ALL below.
command -v makensis >/dev/null || { echo "error: makensis (NSIS) not found" >&2; exit 1; }

cargo build --release --locked -p solidcraft -p solidcraft-cli --target "$TARGET"
# The release profile keeps line tables for crash reports; MinGW puts them inside the .exe (over
# 1 GB), more than NSIS can pack. Ship copies without the debug sections (symbols stay).
BUILT="$ROOT/target/$TARGET/release"
BIN="$ROOT/target/monsolid-stripped"
mkdir -p "$BIN" "$DIST"
for exe in monsolid.exe monsolid-cli.exe; do
  x86_64-w64-mingw32-strip --strip-debug -o "$BIN/$exe" "$BUILT/$exe"
done

SETUP="$DIST/monsolid-$YEAR-$VERSION-windows-x64-setup.exe"
LC_ALL=en_US.UTF-8 makensis -V2 -DROOT="$ROOT" -DVERSION="$VERSION" -DYEAR="$YEAR" -DBINDIR="$BIN" -DOUTFILE="$SETUP" packaging/monsolid/windows/monsolid.nsi

STAGE="$ROOT/target/monsolid-portable/monsolid-$YEAR-$VERSION-windows-x64-portable"
rm -rf "$STAGE" && mkdir -p "$STAGE"
cp "$BIN/monsolid.exe" "$BIN/monsolid-cli.exe" LICENSE-APACHE LICENSE-MIT LICENSE-BRAND NOTICE "$STAGE/"
cp docs/monsolid/INSTALL-mn.md "$STAGE/README-mn.md"
cp docs/monsolid/AI-mn.md "$STAGE/AI-guide-mn.md"
ZIP="$DIST/monsolid-$YEAR-$VERSION-windows-x64-portable.zip"
rm -f "$ZIP"
(cd "$(dirname "$STAGE")" && zip -qr "$ZIP" "$(basename "$STAGE")")

(cd "$DIST" && shasum -a 256 "$(basename "$SETUP")" "$(basename "$ZIP")" > "SHA256SUMS-windows.txt")
ls -la "$SETUP" "$ZIP"
cat "$DIST/SHA256SUMS-windows.txt"
