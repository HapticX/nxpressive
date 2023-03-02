#[
  Provides Scene behavior
]#
import
  ./node,
  ../core/hmacros,
  ../core/rect,
  ../private/templates


type
  HSceneRef* = ref HScene
  HScene* = object of HNode


proc newHScene*(tag: string = "HScene"): HSceneRef =
  ## Creates a new HScene
  defaultNode(HSceneRef)


method draw*(self: HSceneRef) =
  ## Draws all children
