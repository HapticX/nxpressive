#[
  Provides working with Vec2
]#
import
  strformat,
  math,
  ./core

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
func newVec2*(a: Vec2): Vec2 = Vec2(x: a.x, y: a.y)
func newVec2*: Vec2 = Vec2(x: 0f, y: 0f)


# --== Operators ==-- #
template provideOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Vec2): Vec2 {.inline.} =
    Vec2(x: `op`(a.x, b.x), y: `op`(a.y, b.y))
  func `operatorFunc`*(a: float, b: Vec2): Vec2 {.inline.} =
    Vec2(x: `op`(a, b.x), y: `op`(a, b.y))
  func `operatorFunc`*(a: Vec2, b: float): Vec2 {.inline.} =
    Vec2(x: `op`(a.x, b), y: `op`(a.y, b))

template provideOperatorVar(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a: var Vec2, b: Vec2) =
    `op`(a.x, b.x)
    `op`(a.y, b.y)
  func `operatorFunc`*(a: var Vec2, b: float) =
    `op`(a.x, b)
    `op`(a.y, b)

template provideBinOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Vec2): bool {.inline.} =
    `op`(a.x, b.x) and `op`(a.y, b.y)

func `$`*(a: Vec2): string = fmt"vec2({a.x}, {a.y})"

provideOperator(`+`, `+`)
provideOperator(`-`, `-`)
provideOperator(`*`, `*`)
provideOperator(`/`, `/`)

provideOperatorVar(`+=`, `+=`)
provideOperatorVar(`-=`, `-=`)
provideOperatorVar(`*=`, `*=`)
provideOperatorVar(`/=`, `/=`)

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

func aspect*(a: Vec2): float {.inline.} =
  ## Returns ratio of X to Y
  a.x / a.y

func scalar*(a, b: Vec2): float {.inline.} =
  ## Scalar product of a and b
  a.x*b.x + a.y*b.y

func len*(a: Vec2): float =
  ## Vector length
  sqrt(a.x*a.x + a.y*a.y)

func lenSquared*(a: Vec2): float {.inline.} =
  ## Returns squared vector length
  a.x*a.x + a.y*a.y

func interpolate*(a, b: Vec2, t: 0f..1f): Vec2 =
  ## Returns linear interpolated vector
  a + (b - a)*t

func cubic_interpolate*(a, b, ca, cb: Vec2, t: float): Vec2 =
  ## Returns cubic interpolated vector between `a` and `b`.
  Vec2(
    x: cubic_interpolate(a.x, b.x, ca.x, cb.x, t),
    y: cubic_interpolate(a.y, b.y, ca.y, cb.y, t)
  )

func angle*(a: Vec2): float =
  ## Vector angle
  arctan2(a.x, a.y)

func angle2*(a, b: Vec2): float =
  ## Angle between a and b vectors
  let length = a.len
  if length != 0:
    arccos(a.scalar(b) / length)
  else:
    0f

func dot*(a, b: Vec2): float =
  ## Dot product
  a.len * b.len * cos(a.angle2(b))

func dist2*(a, b: Vec2): float {.inline.} =
  ## Distance from a to b
  (b - a).len

func normalized*(a: Vec2): Vec2 {.inline.} =
  ## Normalized vector
  a / a.len

func isNorm*(a: Vec2): bool {.inline.} =
  ## Returns true if a is normailized
  a.x <= 1f and a.y <= 1f

func rotated*(a: Vec2, b: float): Vec2 =
  ## Rotate vector by angle
  Vec2(
    x: a.x*cos(b) - a.y*sin(b),
    y: a.x*sin(b) + a.y*cos(b)
  )

func tangent*(a: Vec2): Vec2 =
  ## Returns perpendicular vector
  a.rotated(PI/2)

func snapped*(a, s: Vec2): Vec2 =
  ## Rounds `a` by `s` step
  Vec2(
    x: s.x * floor(a.x / s.x),
    y: s.y * floor(a.y / s.y)
  )

func bounce*(a, b: Vec2): Vec2 =
  ## Returns vector "bounced off" from the plane, specified by `b` normal vector.
  a - 2*dot(a, b)*b

func clamped*(a: Vec2, length: float): Vec2 =
  ## Returns vector with maximum length
  a * (length / a.len)
