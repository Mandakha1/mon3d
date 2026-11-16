; MonSolid Windows installer (NSIS 3, Unicode). Per-user: no administrator rights needed.
;
;   makensis -DVERSION=0.21.0 -DBINDIR=<folder with monsolid.exe and monsolid-cli.exe> \
;            -DYEAR=2026 -DOUTFILE=<dist>/monsolid-2026-<ver>-windows-x64-setup.exe packaging/monsolid/windows/monsolid.nsi
;
; Installs to %LOCALAPPDATA%\Programs\MonSolid, adds a Start menu entry (and, if ticked, a desktop
; shortcut), registers an uninstaller under "Apps & features", and writes "AI-connect.txt" with the
; exact commands that connect Claude or ChatGPT to this copy of monsolid-cli.exe.
; Silent install: monsolid-<year>-<ver>-windows-x64-setup.exe /S   (add /DESKTOP=1 for the desktop shortcut)

Unicode true
SetCompressor /SOLID lzma
RequestExecutionLevel user

!ifndef VERSION
  !define VERSION "0.0.0"
!endif
!ifndef BINDIR
  !error "pass -DBINDIR=<folder with monsolid.exe and monsolid-cli.exe>"
!endif
!ifndef YEAR
  !define YEAR "2026"
!endif
!ifndef OUTFILE
  !define OUTFILE "monsolid-${YEAR}-${VERSION}-windows-x64-setup.exe"
!endif
; makensis works in the script's folder, so ROOT (the repository) is best passed as an absolute path.
; Path separator for compile-time paths: makensis on Windows needs "\" in File patterns, makensis on
; macOS/Linux needs "/".
!ifdef NSIS_WIN32_MAKENSIS
  !define SEP "\"
!else
  !define SEP "/"
!endif
!ifndef ROOT
  !define ROOT "${__FILEDIR__}${SEP}..${SEP}..${SEP}.."
!endif
!define UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\MonSolid"
; The id Windows notifications (news, courses, offers) are shown under; the app uses the same one.
!define AUMID "MonHydro.MonSolid"
!define FULLNAME "MonSolid ${YEAR}"

Name "${FULLNAME}"
OutFile "${OUTFILE}"
InstallDir "$LOCALAPPDATA\Programs\MonSolid"
InstallDirRegKey HKCU "Software\MonSolid" "InstallDir"
BrandingText "${FULLNAME} (${VERSION})"
VIProductVersion "0.0.0.0"
VIAddVersionKey /LANG=1033 "ProductName" "${FULLNAME}"
VIAddVersionKey /LANG=1033 "FileDescription" "${FULLNAME} setup"
VIAddVersionKey /LANG=1033 "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=1033 "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=1033 "LegalCopyright" "MonSolid, based on SolidCraft by Tangency Labs. MIT OR Apache-2.0."

!include "MUI2.nsh"
!include "FileFunc.nsh"

!define MUI_ICON "${ROOT}${SEP}assets${SEP}icons${SEP}app${SEP}windows${SEP}exports${SEP}solidcraft.ico"
!define MUI_UNICON "${ROOT}${SEP}assets${SEP}icons${SEP}app${SEP}windows${SEP}exports${SEP}solidcraft.ico"
!define MUI_ABORTWARNING
!define MUI_LANGDLL_ALLLANGUAGES
!define MUI_FINISHPAGE_RUN "$INSTDIR\monsolid.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\AI-connect.txt"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "$(ShowAiText)"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${ROOT}${SEP}LICENSE-APACHE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "Mongolian"
!insertmacro MUI_LANGUAGE "English"

LangString SecApp ${LANG_MONGOLIAN} "${FULLNAME} програм"
LangString SecApp ${LANG_ENGLISH} "${FULLNAME} application"
LangString SecDesktop ${LANG_MONGOLIAN} "Ширээний компьютер дээр товчлол"
LangString SecDesktop ${LANG_ENGLISH} "Desktop shortcut"
LangString ShowAiText ${LANG_MONGOLIAN} "Claude / ChatGPT-тэй холбох заавар харах"
LangString ShowAiText ${LANG_ENGLISH} "Show how to connect Claude / ChatGPT"

Function .onInit
  ; Ask for the installer language (Mongolian or English). A silent install never asks: the jump
  ; goes to a label because MUI_LANGDLL_DISPLAY expands to many instructions (IfSilent +2 would
  ; skip only the first, and /S would wait on the dialog forever).
  IfSilent skip_language
  !insertmacro MUI_LANGDLL_DISPLAY
  skip_language:
FunctionEnd

Section "!$(SecApp)" SecMain
  SectionIn RO
  SetOutPath "$INSTDIR"
  File "${BINDIR}${SEP}monsolid.exe"
  File "${BINDIR}${SEP}monsolid-cli.exe"
  File /oname=monsolid.ico "${ROOT}${SEP}assets${SEP}icons${SEP}app${SEP}windows${SEP}exports${SEP}solidcraft.ico"
  File "${ROOT}${SEP}LICENSE-APACHE"
  File "${ROOT}${SEP}LICENSE-MIT"
  File "${ROOT}${SEP}LICENSE-BRAND"
  File "${ROOT}${SEP}NOTICE"
  File /oname=README-mn.md "${ROOT}${SEP}docs${SEP}monsolid${SEP}INSTALL-mn.md"
  File /oname=AI-guide-mn.md "${ROOT}${SEP}docs${SEP}monsolid${SEP}AI-mn.md"

  ; Ready-to-paste commands with this install's real path. MonSolid can also add itself to the
  ; installed AI apps: Preferences > Assistant, or monsolid-cli mcp setup.
  FileOpen $0 "$INSTDIR\AI-connect.txt" w
  FileWrite $0 "${FULLNAME} - AI connection / AI холболт$\r$\n$\r$\n"
  FileWrite $0 "Easiest / Хамгийн амар: MonSolid > Preferences > Assistant, or run:$\r$\n"
  FileWrite $0 '  "$INSTDIR\monsolid-cli.exe" mcp setup$\r$\n$\r$\n'
  FileWrite $0 "Claude Code (terminal):$\r$\n"
  FileWrite $0 '  claude mcp add monsolid -- "$INSTDIR\monsolid-cli.exe" mcp$\r$\n$\r$\n'
  FileWrite $0 "Claude Desktop (claude_desktop_config.json):$\r$\n"
  FileWrite $0 '  { "mcpServers": { "monsolid": { "command": "$INSTDIR\monsolid-cli.exe", "args": ["mcp"] } } }$\r$\n'
  FileWrite $0 "  (JSON: write every \ in the path as \\)$\r$\n$\r$\n"
  FileWrite $0 "ChatGPT desktop app: Settings > MCP servers > Add server > STDIO$\r$\n"
  FileWrite $0 '  command: "$INSTDIR\monsolid-cli.exe"   arguments: mcp$\r$\n$\r$\n'
  FileWrite $0 "Codex CLI:$\r$\n"
  FileWrite $0 '  codex mcp add monsolid -- "$INSTDIR\monsolid-cli.exe" mcp$\r$\n$\r$\n'
  FileWrite $0 "Watch the AI model in the window: start MonSolid (AI) from the Start menu, then use the arguments$\r$\n"
  FileWrite $0 "  mcp --connect 127.0.0.1:7878$\r$\n"
  FileClose $0

  ; Shortcuts carry the year; an older year's shortcuts are replaced.
  CreateDirectory "$SMPROGRAMS\MonSolid"
  Delete "$SMPROGRAMS\MonSolid\*.lnk"
  CreateShortcut "$SMPROGRAMS\MonSolid\${FULLNAME}.lnk" "$INSTDIR\monsolid.exe" "" "$INSTDIR\monsolid.exe" 0
  CreateShortcut "$SMPROGRAMS\MonSolid\${FULLNAME} (AI).lnk" "$INSTDIR\monsolid.exe" "--control 7878" "$INSTDIR\monsolid.exe" 0
  CreateShortcut "$SMPROGRAMS\MonSolid\Uninstall ${FULLNAME}.lnk" "$INSTDIR\uninstall.exe"

  ; Windows notifications from MonSolid show its name and icon (an unpackaged app registers its id).
  WriteRegStr HKCU "Software\Classes\AppUserModelId\${AUMID}" "DisplayName" "${FULLNAME}"
  WriteRegStr HKCU "Software\Classes\AppUserModelId\${AUMID}" "IconUri" "$INSTDIR\monsolid.ico"

  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\MonSolid" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayName" "${FULLNAME}"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UNINST_KEY}" "Publisher" "MonSolid"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayIcon" "$INSTDIR\monsolid.exe"
  WriteRegStr HKCU "${UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UNINST_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "${UNINST_KEY}" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
  WriteRegDWORD HKCU "${UNINST_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNINST_KEY}" "NoRepair" 1
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  WriteRegDWORD HKCU "${UNINST_KEY}" "EstimatedSize" "$0"
SectionEnd

Section /o "$(SecDesktop)" SecDesk
  CreateShortcut "$DESKTOP\${FULLNAME}.lnk" "$INSTDIR\monsolid.exe" "" "$INSTDIR\monsolid.exe" 0
SectionEnd

Function .onInstSuccess
  ; /DESKTOP=1 on a silent install adds the desktop shortcut too.
  ${GetParameters} $0
  ${GetOptions} $0 "/DESKTOP=" $1
  StrCmp $1 "1" 0 +2
  CreateShortcut "$DESKTOP\${FULLNAME}.lnk" "$INSTDIR\monsolid.exe" "" "$INSTDIR\monsolid.exe" 0
FunctionEnd

Section "Uninstall"
  Delete "$INSTDIR\monsolid.exe"
  Delete "$INSTDIR\monsolid-cli.exe"
  Delete "$INSTDIR\monsolid.ico"
  Delete "$INSTDIR\LICENSE-APACHE"
  Delete "$INSTDIR\LICENSE-MIT"
  Delete "$INSTDIR\LICENSE-BRAND"
  Delete "$INSTDIR\NOTICE"
  Delete "$INSTDIR\README-mn.md"
  Delete "$INSTDIR\AI-guide-mn.md"
  Delete "$INSTDIR\AI-connect.txt"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"
  Delete "$SMPROGRAMS\MonSolid\*.lnk"
  RMDir "$SMPROGRAMS\MonSolid"
  Delete "$DESKTOP\MonSolid *.lnk"
  DeleteRegKey HKCU "${UNINST_KEY}"
  DeleteRegKey HKCU "Software\MonSolid"
  DeleteRegKey HKCU "Software\Classes\AppUserModelId\${AUMID}"
  ; Designs and the settings folders (%APPDATA%\MonSolid, %LOCALAPPDATA%\MonSolid) are the user's and stay.
SectionEnd
