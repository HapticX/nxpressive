#[
  Provides working with color
]#
import strformat


type
  Color* = object
    r*, g*, b*, a*: 0f..1f
  BlendMode* = enum
    NORMAL,
    SCREEN,
    MULTIPLY


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


func `$`*(clr: Color): string =
  ## Casts color into string
  fmt"clr({clr.r}, {clr.g}, {clr.b}, {clr.a})"
