#[
  Provides working with color
]#
import
  strformat,
  math


type
  Color* = object
    r*, g*, b*, a*: 0f..1f
  BlendMode* = enum
    NORMAL,
    SCREEN,
    MULTIPLY,
    OVERLAY,
    ADDITION,
    SUBSTRACT,
    DIVIDE,
    DIFFERENCE,
    DARKEN,
    LIGHTEN,
    SOFT_LIGHT


func newColor*(): Color =
  ## Creates a new color object with default values.
  ## Color(1f, 1f, 1f, 1f)
  Color(r: 1f, g: 1f, b: 1f, a: 1f)
func newColor*(r, g, b: 0f..1f): Color =
  ## Creates a new color object with default alpha value.
  ## Color(`r`, `g`, `b`, 1f)
  Color(r: r, g: g, b: b, a: 1)
func newColor*(r, g, b, a: 0f..1f): Color =
  ## Creates a new color.
  ## Color(`r`, `g`, `b`, `a`)
  Color(r: r, g: g, b: b, a: a)


func newColor*(r, g, b: uint): Color =
  ## Creates a new color from unsigned integer with default alpha value (1f).
  Color(
    r: r.float / 255f,
    g: g.float / 255f,
    b: b.float / 255f,
    a: 1f
  )
func newColor*(r, g, b, a: uint): Color =
  ## Creates a new color from unsigned integers.
  Color(
    r: r.float / 255f,
    g: g.float / 255f,
    b: b.float / 255f,
    a: a.float / 255f
  )


func newColor*(hexInteger: int64): Color =
  ## Creates a new color from one HEX 0xRRGGBBAA unsigned integer.
  Color(
    r: ((hexInteger and 0xFF000000) shr 24).float / 255f,
    g: ((hexInteger and 0x00FF0000) shr 16).float / 255f,
    b: ((hexInteger and 0x0000FF00) shr 8).float / 255f,
    a: (hexInteger and 0x000000FF).float / 255f
  )

func newColor*(hexInteger: int): Color =
  ## Creates a new color from one HEX 0xRRGGBB unsigned integer.
  Color(
    r: ((hexInteger and 0xFF0000) shr 16).float / 255f,
    g: ((hexInteger and 0x00FF00) shr 8).float / 255f,
    b: (hexInteger and 0x0000FF).float / 255f,
    a: 1f
  )


# --== Operators ==-- #
func `$`*(clr: Color): string =
  ## Casts color into string
  fmt"clr({clr.r}, {clr.g}, {clr.b}, {clr.a})"

template operator(funcname, op: untyped): untyped =
  func `funcname`*(a, b: Color): Color =
    Color(
      r: clamp(`op`(a.r, b.r), 0f..1f),
      g: clamp(`op`(a.g, b.g), 0f..1f),
      b: clamp(`op`(a.b, b.b), 0f..1f),
      a: clamp(`op`(a.a, b.a), 0f..1f)
    )
  func `funcname`*(a: float32, b: Color): Color =
    Color(
      r: clamp(`op`(a, b.r), 0f..1f),
      g: clamp(`op`(a, b.g), 0f..1f),
      b: clamp(`op`(a, b.b), 0f..1f),
      a: clamp(`op`(a, b.a), 0f..1f)
    )
  func `funcname`*(a: Color, b: float32): Color =
    Color(
      r: clamp(`op`(a.r, b), 0f..1f),
      g: clamp(`op`(a.g, b), 0f..1f),
      b: clamp(`op`(a.b, b), 0f..1f),
      a: clamp(`op`(a.a, b), 0f..1f)
    )

template boolop(funcname, op: untyped): untyped =
  func `funcname`*(a, b: Color): bool =
    (
      `op`(a.r,  b.r) and
      `op`(a.g,  b.g) and
      `op`(a.b,  b.b) and
      `op`(a.a,  b.b)
    )
  func `funcname`*(a: float32, b: Color): bool =
    (
      `op`(a, b.r) and
      `op`(a, b.g) and
      `op`(a, b.b) and
      `op`(a, b.b)
    )
  func `funcname`*(a: Color, b: float32): bool =
    (
      `op`(a.r, b) and
      `op`(a.g, b) and
      `op`(a.b, b) and
      `op`(a.a, b)
    )

operator(`*`, `*`)
operator(`-`, `-`)
operator(`+`, `+`)
operator(`/`, `/`)

boolop(`>`, `>`)
boolop(`<`, `<`)
boolop(`==`, `==`)
boolop(`!=`, `!=`)


# --== Methods ==-- #
template math2clrs(funcname: untyped): untyped =
  func `funcname`*(a, b: Color): Color = 
    Color(
      r: `funcname`(a.r, b.r),
      g: `funcname`(a.g, b.g),
      b: `funcname`(a.b, b.b),
      a: `funcname`(a.a, b.a)
    )
template math2clr(funcname: untyped): untyped =
  func `funcname`*(a: Color): Color = 
    Color(
      r: `funcname`(a.r),
      g: `funcname`(a.g),
      b: `funcname`(a.b),
      a: `funcname`(a.a)
    )

math2clrs(min)
math2clrs(max)
math2clr(sqrt)
math2clr(abs)


func blend*(a, b: Color, blendMode: BlendMode = BlendMode.NORMAL): Color =
  ## Blends two colors
  case blendMode
    of NORMAL:
      b
    of MULTIPLY:
      a*b
    of SCREEN:
      1 - (1 - a)*(1 - b)
    of OVERLAY:
      if a < 0.5:
        2*a*b
      else:
        1 - 2*(1 - a)*(1 - b)
    of ADDITION:
      a+b
    of SUBSTRACT:
      a-b
    of DIVIDE:
      a/b
    of DIFFERENCE:
      if a > b:
        a - b
      else:
        b - a
    of DARKEN:
      min(a, b)
    of LIGHTEN:
      max(a, b)
    of SOFT_LIGHT:
      if b < 0.5:
        2*a*b + a*a*(1 - 2*b)
      else:
        2*a*(1 - b) + sqrt(a)*(2*b - 1)
