#[
  Provides environment
]#
import
  ../core/color


type
  Environment* = ref object
    brightness*: float
    delay*: float
    background_color*: Color
    fullscreen*: bool


func newEnvironment*: Environment =
  ## Creates a new environment
  Environment(
    brightness: 1f,
    delay: 16f,
    background_color: newColor("#212121"),
    fullscreen: false
  )
