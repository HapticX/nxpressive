#[
  Provides working with Vec3
]#
import
  strformat,
  math,
  ./core


type
  Vec3* = object
    x*, y*, z*: float
  Axis* = enum
    AXIS_X = 0
    AXIS_Y = 1
    AXIS_Z = 2


const
  Vec3Up* = Vec3(x: 0f, y: 1f, z: 0f)
  Vec3Down* = Vec3(x: 0f, y: -1f, z: 0f)
  Vec3Right* = Vec3(x: 1f, y: 0f, z: 0f)
  Vec3Left* = Vec3(x: -1f, y: 0f, z: 0f)
  Vec3Toward* = Vec3(x: 0f, y: 0f, z: 1f)
  Vec3Backward* = Vec3(x: 0f, y: 0f, z: -1f)


func newVec3*(x, y, z: float): Vec3 = Vec3(x: x, y: y, z: z)
func newVec3*(xyz: float): Vec3 = Vec3(x: xyz, y: xyz, z: xyz)
func newVec3*(a: Vec3): Vec3 = Vec3(x: a.x, y: a.y, z: a.z)
func newVec3*: Vec3 = Vec3(x: 0f, y: 0f, z: 0f)


# --== Operators ==-- #
template provideOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Vec3): Vec3 {.inline.} =
    Vec3(x: `op`(a.x, b.x), y: `op`(a.y, b.y), z: `op`(a.z, b.z))
  func `operatorFunc`*(a: float, b: Vec3): Vec3 {.inline.} =
    Vec3(x: `op`(a, b.x), y: `op`(a, b.y), z: `op`(a, b.z))
  func `operatorFunc`*(a: Vec3, b: float): Vec3 {.inline.} =
    Vec3(x: `op`(a.x, b), y: `op`(a.y, b), z: `op`(a.z, b))

template provideBinOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Vec3): bool {.inline.} =
    `op`(a.x, b.x) and `op`(a.y, b.y) and `op`(a.z, b.z)

func `$`*(a: Vec3): string = fmt"Vec3({a.x}, {a.y}, {a.z})"

func `[]`*(a: Vec3, index: int): float =
  if index == 0:
    a.x
  elif index == 1:
    a.y
  elif index == 2:
    a.z
  else:
    raise newException(IndexError, fmt"{index} is out of bounds")

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
    func `funcname`*(a: Vec3): Vec3 =
      Vec3(
        x: `funcname`(a.x),
        y: `funcname`(a.y),
        z: `funcname`(a.y)
      )
  else:
    func `funcname`*(a, b: Vec3): Vec3 =
      Vec3(
        x: `funcname`(a.x, b.x),
        y: `funcname`(a.y, b.y),
        z: `funcname`(a.z, b.z)
      )

provideAnyFunc(min)
provideAnyFunc(max)
provideAnyFunc(sqrt, true)
provideAnyFunc(abs, true)

func max_axis*(a: Vec3): Axis =
  ## Returns largest axis
  let m = max(a.x, max(a.y, a.z))
  if m == a.x:
    AXIS_X
  elif m == a.y:
    AXIS_Y
  else:
    AXIS_Z

func min_axis*(a: Vec3): Axis =
  ## Returns smallest axis
  let m = min(a.x, min(a.y, a.z))
  if m == a.x:
    AXIS_X
  elif m == a.y:
    AXIS_Y
  else:
    AXIS_Z

func inversed*(a: Vec3): Vec3 =
  ## Returns inversed vector
  Vec3(x: 1f / a.x, y: 1f / a.y, z: 1f / a.z)

func cross*(a, b: Vec3): Vec3 =
  ## Calculates the cross product of `a` and `b`
  Vec3(
    x: a.y * b.z - a.z * b.y,
    y: a.z * b.x - a.x * b.z,
    z: a.x * b.y - a.y * b.x
  )

func dot*(a, b: Vec3): float {.inline.} =
  ## dot product of a and b
  a.x*b.x + a.y*b.y + a.z*b.z

func len*(a: Vec3): float =
  ## Vector length
  sqrt(a.x*a.x + a.y*a.y + a.z*a.z)

func lenSquared*(a: Vec3): float {.inline.} =
  ## Returns squared vector length
  a.x*a.x + a.y*a.y + a.z*a.z

func interpolate*(a, b: Vec3, t: 0f..1f): Vec3 =
  ## Returns linear interpolated vector
  a + (b - a)*t

func cubic_interpolate*(a, b, ca, cb: Vec3, t: float): Vec3 =
  ## Returns cubic interpolated vector between `a` and `b`.
  Vec3(
    x: cubic_interpolate(a.x, b.x, ca.x, cb.x, t),
    y: cubic_interpolate(a.y, b.y, ca.y, cb.y, t),
    z: cubic_interpolate(a.z, b.z, ca.z, cb.z, t)
  )

func rotated*(a, axis: Vec3, angle: float): Vec3 =
  ## Rotates a vector `a` around an `axis` by `angle`
  ## 
  ## Arguments:
  ## - `a` the vector to be rotated
  ## - `axis` the axis of rotation, represent as `Vec3` object
  ## - `angle` the angle in radians.
  let
    c = cos(angle)
    s = sin(angle)
    t = 1f - c
    (x, y, z) = (a.x, a.y, a.z)
    (u, v, w) = (axis.x, axis.y, axis.z)
  Vec3(
    x: x * (c + u * u * t) + y * (u * v * t - w * s) + z * (u * w * t + v * s),
    y: x * (v * u * t + w * s) + y * (c * v * v * t) + z * (v * w * t - u * s),
    z: x * (w * u * t - v * s) + y * (w * v * t + u * s) + z * (c + w * w * t)
  )

func rotatedX*(a: Vec3, angle: float): Vec3 {.inline.} =
  ## Rotates vector `a` around x-axis by `angle`.
  rotated(a, Vec3Right, angle)

func rotatedY*(a: Vec3, angle: float): Vec3 {.inline.} =
  ## Rotates vector `a` around y-axis by `angle`.
  rotated(a, Vec3Up, angle)

func rotatedZ*(a: Vec3, angle: float): Vec3 {.inline.} =
  ## Rotates vector `a` around z-axis by `angle`.
  rotated(a, Vec3Toward, angle)

func angle2*(a, b: Vec3): float =
  ## Calculates the angle between `a` and `b` in radians
  let m = a.len * b.len
  if m == 0:
    0f
  else:
    arccos(dot(a, b) / m)

func dist2*(a, b: Vec3): float {.inline.} =
  ## Distance from a to b
  (b - a).len

func normalized*(a: Vec3): Vec3 {.inline.} =
  ## Normalized vector
  a / a.len

func isNorm*(a: Vec3): bool {.inline.} =
  ## Returns true if a is normailized
  a.x <= 1f and a.y <= 1f

func snapped*(a, s: Vec3): Vec3 =
  ## Rounds `a` by `s` step
  Vec3(
    x: s.x * floor(a.x / s.x),
    y: s.y * floor(a.y / s.y),
    z: s.z * floor(a.z / s.z)
  )

func bounce*(a, b: Vec3): Vec3 =
  ## Returns vector "bounced off" from the plane, specified by `b` normal vector.
  a - 2*dot(a, b)*b

func clamped*(a: Vec3, length: float): Vec3 =
  ## Returns vector with maximum length
  a * (length / a.len)


func reflect*(a, plane: Vec3): Vec3 {.inline.} =
  ## Reflects the vector `a` along the given plane by its normal vector `plane`
  a - plane * 2 * dot(a, plane)
