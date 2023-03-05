#[
  Provides Rect behavior
]#
import
  ./vec2


type
  Rect* = object
    x*, y*, w*, h*: float


func newRect*: Rect =
  Rect(x: 0f, y: 0f, w: 1f, h: 1f)

func newRect*(w, h: float): Rect =
  Rect(x: 0f, y: 0f, w: w, h: h)

func newRect*(x, y, w, h: float): Rect =
  Rect(x: x, y: y, w: w, h: h)

func newRect*(wh: Vec2): Rect =
  Rect(x: 0f, y: 0f, w: wh.x, h: wh.y)

func newRect*(xy, wh: Vec2): Rect =
  Rect(x: xy.x, y: xy.y, w: wh.x, h: wh.y)


func left*(a: Rect): float = a.x
func right*(a: Rect): float = a.x+a.w
func top*(a: Rect): float = a.y
func bottom*(a: Rect): float = a.y+a.h


func contains*(a, b: Rect): bool =
  ## Returns true when rect `a` contains rect `b`
  a.x <= b.x and a.y <= b.y and a.w >= b.w and a.h >= b.h


func contains*(a: Rect, b: Vec2): bool =
  ## Returns true when rect `a` contains point `b`
  a.x <= b.x and a.x+a.w >= b.x and a.y <= b.y and a.y+a.h >= b.y


func contains*(a: Rect, b, c: Vec2): bool =
  ## Returns true when rect `a` contains segment `b`, `c`
  a.contains(b) and a.contains(b)
