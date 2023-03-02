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
