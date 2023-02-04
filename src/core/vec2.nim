#[
  Provides working with Vec2
]#
import strformat

type
  Vec2* = object
    x*, y*: float

const
  Vec2Up* = Vec2(x: 0f, y: 1f)
  Vec2Down* = Vec2(x: 0f, y: -1f)
  Vec2Right* = Vec2(x: 1f, y: 0f)
  Vec2Left* = Vec2(x: -1f, y: 0f)

func newVec2*(x, y: float32): Vec2 = Vec2(x: x, y: y)
func newVec2*(xy: float32): Vec2 = Vec2(x: xy, y: xy)
func newVec2*: Vec2 = Vec2(x: 0f, y: 0f)


# --== Operators ==-- #
template provideOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Vec2): Vec2 =
    Vec2(x: `op`(a.x, b.x), y: `op`(a.y, b.y))
  func `operatorFunc`*(a: float, b: Vec2): Vec2 =
    Vec2(x: `op`(a, b.x), y: `op`(a, b.y))
  func `operatorFunc`*(a: Vec2, b: float): Vec2 =
    Vec2(x: `op`(a.x, b), y: `op`(a.y, b))

template provideBinOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Vec2): bool =
    `op`(a.x, b.x) and `op`(a.y, b.y)

func `$`*(a: Vec2): string = fmt"vec2({a.x}, {a.y})"

provideOperator(`+`, `+`)
provideOperator(`-`, `-`)
provideOperator(`*`, `*`)
provideOperator(`/`, `/`)

provideBinOperator(`==`, `==`)
provideBinOperator(`!=`, `!=`)
provideBinOperator(`>`, `>`)
provideBinOperator(`<`, `<`)
