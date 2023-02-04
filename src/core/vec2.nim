#[
  Provides working with Vec2
]#
import
  strformat,
  math

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

# --== Methods ==-- #
template provideAnyFunc(funcname: untyped, oneArg: bool = false): untyped =
  when oneArg:
    func `funcname`*(a: Vec2): Vec2 =
      Vec2(
        x: `funcname`(a.x),
        y: `funcname`(a.y)
      )
  else:
    func `funcname`*(a, b: Vec2): Vec2 =
      Vec2(
        x: `funcname`(a.x, b.x),
        y: `funcname`(a.y, b.y)
      )

provideAnyFunc(min)
provideAnyFunc(max)
provideAnyFunc(sqrt, true)
provideAnyFunc(abs, true)

func scalar*(a, b: Vec2): float =
  a.x*b.x + a.y*b.y

func len*(a: Vec2): float =
  sqrt(a.x*a.x + a.y*a.y)

func angle*(a: Vec2): float =
  let length = a.len
  if length != 0:
    arccos(a.x+a.y / length)
  else:
    0f

func angle2*(a, b: Vec2): float =
  let length = a.len
  if length != 0:
    arccos(a.scalar(b) / length)
  else:
    0f

func dot*(a, b: Vec2): float =
  a.len * b.len * cos(a.angle2(b))

func dist2*(a, b: Vec2): float =
  (b - a).len

func normalized*(a: Vec2): Vec2 =
  a / a.len

func rotated*(a: Vec2, b: float): Vec2 =
  Vec2(
    x: a.x*cos(b) - a.y*sin(b),
    y: a.x*sin(b) + a.y*cos(b)
  )
