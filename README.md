<h1 align="center">MonSolid 2026</h1>

<p align="center">
  <b>Монгол инженерүүдэд зориулсан үнэгүй, нээлттэй эхийн параметрт 3D CAD програм.</b><br>
  Гараар загварчилна — эсвэл Claude, ChatGPT-ээр шууд 3D загвар хийлгэнэ.
</p>

<p align="center">
  <a href="docs/monsolid/INSTALL-mn.md">Суулгах</a> ·
  <a href="docs/monsolid/AI-mn.md">AI-аар загварчлуулах</a> ·
  <a href="#english">English</a> ·
  <a href="https://cad.monhydro.com">Сургалт</a>
</p>

---

## MonSolid гэж юу вэ?

SolidWorks, Fusion-тай төстэй параметрт 3D CAD: хэмжээстэй эскиз, хязгаарлалт, шахаж өргөх, эргүүлж
үүсгэх, замаар болон огтлолоор үүсгэх, булан дугуйлах, бүрхүүл, нүх, эрэг, массив, угсралт, хуудас
металл. Хэмжээсээ өөрчлөхөд загвар өөрөө дахин үүснэ. Pure Rust дээр бичигдсэн
[SolidCraft](https://github.com/tangency-labs/solidcraft) дээр суурилсан.

| | |
|---|---|
| **Хэл** | Монгол (бүрэн, 6,800+ мөр) ба англи — програм дахин асаалгүй солино. Бусад 36 хэл ч бий. |
| **AI** | MCP сервер өөрт нь суугаатай: Claude Desktop, Claude Code, ChatGPT desktop, Codex, Cursor. Preferences → Assistant дээр нэг товшилтоор холбоно. |
| **Файл** | STEP, IGES, STL, 3MF, OBJ, glTF; `.sc` төсөл (SolidCraft-тай нийцтэй) |
| **Мэдээ** | Шинэ мэдээ, сургалт, саналыг програм дотор болон Windows мэдэгдлээр хүргэнэ (унтрааж болно, хувийн мэдээлэл цуглуулахгүй) |
| **Үнэ** | Үнэгүй, нээлттэй эх |

## AI-аар загварчлуулах — 1 минутад

```bash
monsolid-cli mcp setup
```

Дараа нь Claude-д: *«MonSolid дээр DN50 фланц загварчил: гадна диаметр 165 мм, зузаан 18 мм,
125 мм-ийн тойрог дээр 4 ширхэг M16 нүх. STEP болгон хадгал.»*

## Эх кодоос build хийх

```bash
cargo run --release -p solidcraft              # MonSolid програм (binary: monsolid)
cargo build --release -p solidcraft-cli        # monsolid-cli (MCP сервер, хөрвүүлэгч)
packaging/monsolid/build-windows.sh            # macOS/Linux дээрээс Windows суулгагч
```

Дэлгэрэнгүй: [docs/monsolid/FORK.md](docs/monsolid/FORK.md).

## Эх сурвалж ба лиценз

MonSolid нь Tangency Labs болон хувь нэмэр оруулагчдын [SolidCraft](https://github.com/tangency-labs/solidcraft)
дээр суурилсан. Код нь **MIT OR Apache-2.0** ([LICENSE-MIT](LICENSE-MIT), [LICENSE-APACHE](LICENSE-APACHE),
[NOTICE](NOTICE)); интерфейсийн хэсэг (`crates/ui-kit`, `crates/look`, `crates/theme`) нь
[LICENSE-BRAND](LICENSE-BRAND)-ийн дагуу. MonSolid бол Tangency Labs-ийн бүтээгдэхүүн биш.

---

<a id="english"></a>
## English

**MonSolid 2026** is a free, open-source parametric 3D CAD application for Mongolian engineers,
based on [SolidCraft](https://github.com/tangency-labs/solidcraft) by Tangency Labs and its
contributors. It adds a complete Mongolian interface (switchable with English), its own name, year
and mark, a news feed for courses and announcements (in-app cards and Windows notifications, no
tracking, can be turned off) and a per-user Windows installer. Model by hand, or let Claude or
ChatGPT model for you over the built-in MCP server.

Docs: [install (mn)](docs/monsolid/INSTALL-mn.md) · [AI control (mn)](docs/monsolid/AI-mn.md) ·
[fork notes](docs/monsolid/FORK.md) · [upstream SolidCraft README](docs/upstream/SolidCraft-README.md)

Code licence: MIT OR Apache-2.0, like SolidCraft; interface material under LICENSE-BRAND. MonSolid is
not affiliated with or endorsed by Tangency Labs.
