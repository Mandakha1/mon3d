# Mon3D-г Claude болон ChatGPT-ээр удирдах

Mon3D нь **MCP** (Model Context Protocol) сервертэй (`mon3d-cli mcp`). AI туслах эскиз зурж,
хэмжээс тавьж, шахаж өргөх, булан дугуйлах, бүрхүүл, нүх, угсралт хийж, STEP/STL болгон хадгална.
Ажлаа `inspect_design`, `screenshot` хэрэгслээр өөрөө шалгадаг.

## Хамгийн амар зам

Mon3D → **Preferences → Assistant** (эсвэл Тусламж → **Connect AI assistants…**). Компьютерт
суусан Claude Desktop, Claude Code, Codex, Cursor гэх мэт програмуудад Mon3D-г өөрөө нэмнэ.
Дараа нь тэр програмыг дахин асаана.

Командын мөрөөр: `mon3d-cli mcp setup` (зөвхөн харах бол `--dry-run`; нээлттэй цонхыг удирдах
бол `--live`).

## Гараар тохируулах

Windows дээр `mon3d-cli.exe`-ийн зам: `%LOCALAPPDATA%\Programs\Mon3D\mon3d-cli.exe`.
Суулгагч бэлэн командуудыг `AI-connect.txt` файлд бичдэг.

| Програм | Тохиргоо |
|---|---|
| Claude Code | `claude mcp add mon3d -- "<зам>\mon3d-cli.exe" mcp` |
| Claude Desktop | `claude_desktop_config.json` → `"mon3d": {"command": "<зам>\\mon3d-cli.exe", "args": ["mcp"]}` |
| ChatGPT desktop | Settings → MCP servers → Add server → STDIO, command: `mon3d-cli.exe`-ийн зам, arguments: `mcp` |
| Codex CLI | `codex mcp add mon3d -- "<зам>\mon3d-cli.exe" mcp` |

`mcp` дангаараа цонхгүй (headless) ажиллана. Нээлттэй Mon3D цонхонд AI-ийн загварчлахыг шууд харах
бол Start цэс → **Mon3D 2026 (AI)**-аар нээгээд аргументыг `mcp --connect 127.0.0.1:7878` болгоно.

## Жишээ даалгавар

- «Mon3D дээр 80×60×40 мм хайрцаг хий, ханын зузаан 2 мм, дээд талыг нээлттэй үлдээ, булангуудыг
  3 мм дугуйл. Дараа нь STEP болгон хадгал.»
- «DN50 фланц загварчил: гадна диаметр 165 мм, зузаан 18 мм, 4 ширхэг M16 боолтны нүх 125 мм-ийн
  тойрог дээр.»
- «Радиаторын бэхэлгээний хаалт (bracket) хий: 3 мм хуудас металл, 2 нугалаа, 2 ширхэг 8 мм нүх.»

## Аюулгүй байдал

- Control порт зөвхөн `127.0.0.1` (таны компьютер) дээр сонсдог, токеноор хамгаалагдсан.
- AI файл хадгалах, нээх эрхтэй тул чухал төслөө нөөцлөөрэй.
