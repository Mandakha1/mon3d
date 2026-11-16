# MonSolid (SolidCraft) — Mongolian 3D CAD glossary and rules

Read `~/moncad/docs/moncad/mn-glossary.md` first (the MonCad 2D glossary): its register, prompt
patterns, menu words, view names and 2D terms apply here too. This file adds the 3D parametric
terms and overrides it where they differ. SolidCraft's own English glossary, with a "For
translators" note per term, is `~/monsolid/docs/book/src/reference/glossary.md`; read the entry
of any term you are unsure about. The Russian text given beside many rows is a reference for
meaning only (it is partial and sometimes stale); always translate from the English.

Audience: Mongolian mechanical, civil and heating engineers who know SolidWorks, Fusion, Kompas or
AutoCAD, often in Russian or English. Short, natural, modern Mongolian software language, polite
neutral register. Sentence case: only the first letter (and proper names) capitalised, also for
`cmd.*` labels that are Title Case in English ("Home View" → "Үндсэн харагдац").

## Hard format rules (the validator enforces them)

1. Keep every `{placeholder}` exactly (same names, same count). You may move it in the sentence.
2. Mirror leading/trailing spaces and the number of line breaks of the English exactly.
3. Ellipsis: if the English ends with `...` or `…`, the translation ends with the same; otherwise it must not.
4. Text inside backticks stays as it is (it is a command id, key or code): `sketch.line`, `--control`.
5. Keep as they are: SolidCraft, MCP, STEP, IGES, STL, 3MF, OBJ, glTF, URDF, DXF, SVG, PDF, PNG, JSON,
   CPU, GPU, HDR, RGB, ID, URL, API, CLI, AI, Claude, ChatGPT, Codex, GitHub, Windows, macOS, Linux,
   Discord, file extensions (.sc), units and symbols (mm, cm, m, in, g, kg, N, Pa, MPa, °, %, ×),
   keyboard keys and shortcuts (Ctrl+S, ⌘, ⇧, Esc, Enter, F3), standard names (ISO, DIN, GOST, ANSI).
6. Use real Mongolian letters Ө ө Ү ү (U+04E8/04E9/04AE/04AF); never Latin O/Y or Kazakh/Ukrainian letters.
7. A count never inflects the noun: "{count} bodies" → "{count} бие". Mongolian has no plural agreement here.
8. A message that is only a unit, symbol, number format or a name kept above stays identical.
9. "Specify/Select/Enter X" → "X заана уу / сонгоно уу / оруулна уу". Questions end with "уу/үү?".
10. Never use "чи". Never add explanations that are not in the English.

## Core 3D terms

| English | Mongolian | Notes |
|---|---|---|
| design | төсөл | the open model; New Design → Шинэ төсөл; Design Properties → Төслийн шинж чанар |
| design file | төслийн файл | "file" only for what is on disk |
| model (3D geometry, generic) | загвар | an AI model → AI загвар |
| body | бие | solid body → цул бие; surface body → гадаргуун бие |
| component | компонент | not an occurrence |
| occurrence | оруулга | one placed copy of a component (Bolt:3) |
| pattern instance | массивын хувь | |
| assembly | угсралт | |
| sub-assembly | дэд угсралт | |
| joint | холбоос | rigid → хатуу холбоос; revolute → эргэх; slider → гулсах; cylindrical → цилиндр; planar → хавтгай; ball → бөмбөлөг |
| rigid group | хатуу бүлэг | |
| ground / unground (occurrence) | байрлалыг бэхлэх / бэхэлгээг авах | Fix (sketch constraint) is Бэхлэх |
| feature (timeline step) | үйлдэл | "AI features/capabilities" → AI боломжууд (not үйлдэл) |
| timeline | хугацааны шугам | undo history is Түүх |
| history marker | түүхийн тэмдэглэгээ | |
| browser (model tree panel) | загварын мод | never хөтөч; web browser → хөтөч |
| folder (browser) / group | хавтас / бүлэг | |
| sketch | эскиз | Sketch1 → Эскиз1 |
| sketch entity / curve | эскизийн элемент / муруй | not an edge |
| construction entity | туслах элемент | construction line → туслах шугам |
| construction plane / axis / point | туслах хавтгай / тэнхлэг / цэг | browser "Construction" folder → Туслах |
| profile | профиль | a closed sketch region |
| region | муж | |
| constraint | хязгаарлалт | |
| dimension | хэмжээс | driven → хамааралтай хэмжээс; driving → удирдах хэмжээс |
| fully constrained / under-constrained / over-constrained | бүрэн тодорхойлогдсон / дутуу тодорхойлогдсон / илүү тодорхойлогдсон | |
| coincident · collinear · concentric · parallel · perpendicular · tangent · horizontal · vertical · equal · symmetric · midpoint · fix · smooth | давхцах · нэг шулуун дээр · нэг төвтэй · параллель · перпендикуляр · шүргэгч · хэвтээ · босоо · тэнцүү · тэгш хэмтэй · дунд цэг · бэхлэх · гөлгөр | |
| parameter · expression · configuration | параметр · илэрхийлэл · конфигураци | |
| extrude | шахаж өргөх (noun: шахалт) | |
| revolve | эргүүлж үүсгэх (noun: эргүүлэлт) | |
| sweep | замаар үүсгэх | |
| loft | огтлолоор үүсгэх | |
| fillet | булан дугуйлах (noun: дугуйлалт) | |
| chamfer | ташуу огтлох (noun: ташуу огтлол) | |
| shell | бүрхүүл (verb: хөндийлөх) | |
| draft (taper on faces) | налуу | a draft of a document → ноорог |
| hole · thread · tapped | нүх · эрэг · эрэгтэй | counterbore → цилиндр хонхор; countersink → конус хонхор |
| pattern (rectangular / circular / along path) | массив (тэгш өнцөгт / тойрог / замын) | |
| mirror | толин тусгал | |
| split · combine · join · cut · intersect · new body (operation) | хуваах · нийлүүлэх · нэгтгэх · хасах · огтлолцол · шинэ бие | Cut (clipboard) → Хайчлах |
| offset (face/plane) | зэрэгцээ шилжүүлэх | 2D offset command → Зэрэгцээ хуулах |
| thicken · stitch · patch · trim · extend | зузаалах · оёх · нөхөх · тайрах · сунгах | |
| face · edge · vertex · loop | нүүр · ирмэг · орой · гогцоо | |
| plane · axis · point · origin | хавтгай · тэнхлэг · цэг · эх цэг | |
| normal (vector) | нормаль | "normal" = ordinary → ердийн; BOM normal → энгийн |
| suppress / unsuppress | түр унтраах / дахин асаах | |
| sheet metal | хуудас металл | flange → фланц; hem → нугалаас; bend → нугалаа; fold / unfold → нугалах / дэлгэх; flat pattern → дэлгэмэл; relief → сулруулга; K-factor → K-коэффициент |
| frame member / end cap | рамын элемент / таг хавтан | |
| material / appearance | материал / харагдах байдал | material sets mass; appearance only looks |
| mass · density · volume · area · center of mass · moment of inertia | масс · нягт · эзэлхүүн · талбай · массын төв · инерцийн момент | |
| bill of materials | материалын жагсаалт | BOM in labels → материалын жагсаалт |
| part number | эд ангийн дугаар | |
| interference · clearance · gap | давхцал · завсар · зай | |
| motion study · contact set | хөдөлгөөний судалгаа · шүргэлтийн бүлэг | |
| section analysis · measure · inspect | огтлолын шинжилгээ · хэмжих · шалгах | INSPECT panel → ШАЛГАХ |
| render · renderer · camera · light · environment · shadow · reflection | рендер · рендерлэгч · камер · гэрэл · орчин · сүүдэр · тусгал | caustics → каустик; photon → фотон; sample → түүвэр; denoise → шуугиан арилгах; ray tracing → цацраг мөрдөлт; path tracing → зам мөрдөлт |
| workspace | ажлын орчин | DESIGN, RENDER workspace tabs: ТӨСӨЛ, РЕНДЕР |
| home view · view cube · orbit · pan · zoom · fit | үндсэн харагдац · харах куб · тойруулан харах · гүйлгэх · томруулах · бүгдийг харуулах | |
| perspective / orthographic | перспектив / ортографик | |
| wireframe · shaded · hidden edges | утсан хүрээ · сүүдэртэй · далд ирмэг | |
| import / export / insert | импортлох / экспортлох / оруулах | |
| preferences / settings | тохиргоо | |
| assistant / agent (AI) | AI туслах | the MCP server / control channel → MCP сервер / удирдлагын суваг |
| plugin | залгаас | |
| crash report | алдааны тайлан | |
| undo / redo | буцаах / дахин хийх | |

ALL-CAPS toolbar panel names stay ALL-CAPS in Mongolian: CREATE → ҮҮСГЭХ, MODIFY → ӨӨРЧЛӨХ,
CONSTRUCT → ТУСЛАХ, INSPECT → ШАЛГАХ, INSERT → ОРУУЛАХ, ASSEMBLE → УГСРАХ, SKETCH → ЭСКИЗ,
SELECT → СОНГОХ, CONSTRAINTS → ХЯЗГААРЛАЛТ, FINISH SKETCH → ЭСКИЗ ДУУСГАХ.
