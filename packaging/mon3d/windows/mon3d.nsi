; Mon3D Windows installer (NSIS 3, Unicode). Per-user: no administrator rights needed.
;
;   makensis -DVERSION=0.21.0 -DBINDIR=<folder with mon3d.exe and mon3d-cli.exe> \
;            -DYEAR=2026 -DOUTFILE=<dist>/mon3d-2026-<ver>-windows-x64-setup.exe packaging/mon3d/windows/mon3d.nsi
;
; Installs to %LOCALAPPDATA%\Programs\Mon3D, adds a Start menu entry (and, if ticked, a desktop
; shortcut), registers an uninstaller under "Apps & features", and writes "AI-connect.txt" with the
; exact commands that connect Claude or ChatGPT to this copy of mon3d-cli.exe.
; Silent install: mon3d-<year>-<ver>-windows-x64-setup.exe /S   (add /DESKTOP=1 for the desktop shortcut)

Unicode true
SetCompressor /SOLID lzma
RequestExecutionLevel user

!ifndef VERSION
  !define VERSION "0.0.0"
!endif
!ifndef BINDIR
  !error "pass -DBINDIR=<folder with mon3d.exe and mon3d-cli.exe>"
!endif
!ifndef YEAR
  !define YEAR "2026"
!endif
!ifndef OUTFILE
  !define OUTFILE "mon3d-${YEAR}-${VERSION}-windows-x64-setup.exe"
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
!define UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Mon3D"
; The id Windows notifications (news, courses, offers) are shown under; the app uses the same one.
!define AUMID "MonHydro.Mon3D"
!define FULLNAME "Mon3D ${YEAR}"

Name "${FULLNAME}"
OutFile "${OUTFILE}"
InstallDir "$LOCALAPPDATA\Programs\Mon3D"
InstallDirRegKey HKCU "Software\Mon3D" "InstallDir"
BrandingText "${FULLNAME} (${VERSION})"
VIProductVersion "0.0.0.0"
VIAddVersionKey /LANG=1033 "ProductName" "${FULLNAME}"
VIAddVersionKey /LANG=1033 "FileDescription" "${FULLNAME} setup"
VIAddVersionKey /LANG=1033 "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=1033 "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Mon3D, based on SolidCraft by Tangency Labs. MIT OR Apache-2.0."

!include "MUI2.nsh"
!include "FileFunc.nsh"

!define MUI_ICON "${ROOT}${SEP}assets${SEP}icons${SEP}app${SEP}windows${SEP}exports${SEP}solidcraft.ico"
!define MUI_UNICON "${ROOT}${SEP}assets${SEP}icons${SEP}app${SEP}windows${SEP}exports${SEP}solidcraft.ico"
!define MUI_ABORTWARNING
!define MUI_LANGDLL_ALLLANGUAGES
!define MUI_FINISHPAGE_RUN "$INSTDIR\mon3d.exe"
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

  ; Mon3D 2026 was first released as "MonSolid 2026" (v0.43.0, 2026-11-16). Replace that install:
  ; run its own uninstaller (it keeps the user's designs), then move its settings and recovery
  ; folders to Mon3D's names when Mon3D has none yet.
  ReadRegStr $1 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\MonSolid" "InstallLocation"
  StrCmp $1 "" old_done
  IfFileExists "$1\uninstall.exe" 0 old_done
  ExecWait '"$1\uninstall.exe" /S _?=$1'
  Delete "$1\uninstall.exe"
  RMDir "$1"
  old_done:
  IfFileExists "$LOCALAPPDATA\Mon3D\*.*" +3 0
  IfFileExists "$LOCALAPPDATA\MonSolid\*.*" 0 +2
  Rename "$LOCALAPPDATA\MonSolid" "$LOCALAPPDATA\Mon3D"
  IfFileExists "$APPDATA\Mon3D\*.*" +3 0
  IfFileExists "$APPDATA\MonSolid\*.*" 0 +2
  Rename "$APPDATA\MonSolid" "$APPDATA\Mon3D"

  SetOutPath "$INSTDIR"
  File "${BINDIR}${SEP}mon3d.exe"
  File "${BINDIR}${SEP}mon3d-cli.exe"
  File /oname=mon3d.ico "${ROOT}${SEP}assets${SEP}icons${SEP}app${SEP}windows${SEP}exports${SEP}solidcraft.ico"
  File "${ROOT}${SEP}LICENSE-APACHE"
  File "${ROOT}${SEP}LICENSE-MIT"
  File "${ROOT}${SEP}LICENSE-BRAND"
  File "${ROOT}${SEP}NOTICE"
  File /oname=README-mn.md "${ROOT}${SEP}docs${SEP}mon3d${SEP}INSTALL-mn.md"
  File /oname=AI-guide-mn.md "${ROOT}${SEP}docs${SEP}mon3d${SEP}AI-mn.md"

  ; Ready-to-paste commands with this install's real path. Mon3D can also add itself to the
  ; installed AI apps: Preferences > Assistant, or mon3d-cli mcp setup.
  FileOpen $0 "$INSTDIR\AI-connect.txt" w
  FileWrite $0 "${FULLNAME} - AI connection / AI холболт$\r$\n$\r$\n"
  FileWrite $0 "Easiest / Хамгийн амар: Mon3D > Preferences > Assistant, or run:$\r$\n"
  FileWrite $0 '  "$INSTDIR\mon3d-cli.exe" mcp setup$\r$\n$\r$\n'
  FileWrite $0 "Claude Code (terminal):$\r$\n"
  FileWrite $0 '  claude mcp add mon3d -- "$INSTDIR\mon3d-cli.exe" mcp$\r$\n$\r$\n'
  FileWrite $0 "Claude Desktop (claude_desktop_config.json):$\r$\n"
  FileWrite $0 '  { "mcpServers": { "mon3d": { "command": "$INSTDIR\mon3d-cli.exe", "args": ["mcp"] } } }$\r$\n'
  FileWrite $0 "  (JSON: write every \ in the path as \\)$\r$\n$\r$\n"
  FileWrite $0 "ChatGPT desktop app: Settings > MCP servers > Add server > STDIO$\r$\n"
  FileWrite $0 '  command: "$INSTDIR\mon3d-cli.exe"   arguments: mcp$\r$\n$\r$\n'
  FileWrite $0 "Codex CLI:$\r$\n"
  FileWrite $0 '  codex mcp add mon3d -- "$INSTDIR\mon3d-cli.exe" mcp$\r$\n$\r$\n'
  FileWrite $0 "Watch the AI model in the window: start Mon3D (AI) from the Start menu, then use the arguments$\r$\n"
  FileWrite $0 "  mcp --connect 127.0.0.1:7878$\r$\n"
  FileClose $0

  ; Shortcuts carry the year; an older year's shortcuts are replaced.
  CreateDirectory "$SMPROGRAMS\Mon3D"
  Delete "$SMPROGRAMS\Mon3D\*.lnk"
  CreateShortcut "$SMPROGRAMS\Mon3D\${FULLNAME}.lnk" "$INSTDIR\mon3d.exe" "" "$INSTDIR\mon3d.exe" 0
  CreateShortcut "$SMPROGRAMS\Mon3D\${FULLNAME} (AI).lnk" "$INSTDIR\mon3d.exe" "--control 7878" "$INSTDIR\mon3d.exe" 0
  CreateShortcut "$SMPROGRAMS\Mon3D\Uninstall ${FULLNAME}.lnk" "$INSTDIR\uninstall.exe"

  ; Windows notifications from Mon3D show its name and icon (an unpackaged app registers its id).
  WriteRegStr HKCU "Software\Classes\AppUserModelId\${AUMID}" "DisplayName" "${FULLNAME}"
  WriteRegStr HKCU "Software\Classes\AppUserModelId\${AUMID}" "IconUri" "$INSTDIR\mon3d.ico"

  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Mon3D" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayName" "${FULLNAME}"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "${UNINST_KEY}" "Publisher" "Mon3D"
  WriteRegStr HKCU "${UNINST_KEY}" "DisplayIcon" "$INSTDIR\mon3d.exe"
  WriteRegStr HKCU "${UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "${UNINST_KEY}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "${UNINST_KEY}" "QuietUninstallString" '"$INSTDIR\uninstall.exe" /S'
  WriteRegDWORD HKCU "${UNINST_KEY}" "NoModify" 1
  WriteRegDWORD HKCU "${UNINST_KEY}" "NoRepair" 1
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  WriteRegDWORD HKCU "${UNINST_KEY}" "EstimatedSize" "$0"
SectionEnd

Section /o "$(SecDesktop)" SecDesk
  CreateShortcut "$DESKTOP\${FULLNAME}.lnk" "$INSTDIR\mon3d.exe" "" "$INSTDIR\mon3d.exe" 0
SectionEnd

Function .onInstSuccess
  ; /DESKTOP=1 on a silent install adds the desktop shortcut too.
  ${GetParameters} $0
  ${GetOptions} $0 "/DESKTOP=" $1
  StrCmp $1 "1" 0 +2
  CreateShortcut "$DESKTOP\${FULLNAME}.lnk" "$INSTDIR\mon3d.exe" "" "$INSTDIR\mon3d.exe" 0
FunctionEnd

Section "Uninstall"
  Delete "$INSTDIR\mon3d.exe"
  Delete "$INSTDIR\mon3d-cli.exe"
  Delete "$INSTDIR\mon3d.ico"
  Delete "$INSTDIR\LICENSE-APACHE"
  Delete "$INSTDIR\LICENSE-MIT"
  Delete "$INSTDIR\LICENSE-BRAND"
  Delete "$INSTDIR\NOTICE"
  Delete "$INSTDIR\README-mn.md"
  Delete "$INSTDIR\AI-guide-mn.md"
  Delete "$INSTDIR\AI-connect.txt"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"
  Delete "$SMPROGRAMS\Mon3D\*.lnk"
  RMDir "$SMPROGRAMS\Mon3D"
  Delete "$DESKTOP\Mon3D *.lnk"
  DeleteRegKey HKCU "${UNINST_KEY}"
  DeleteRegKey HKCU "Software\Mon3D"
  DeleteRegKey HKCU "Software\Classes\AppUserModelId\${AUMID}"
  ; Designs and the settings folders (%APPDATA%\Mon3D, %LOCALAPPDATA%\Mon3D) are the user's and stay.
SectionEnd
