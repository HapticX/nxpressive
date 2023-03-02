#[
  Provides Scene behavior
]#
import
  ./node,
  ../core/hmacros,
  ../core/rect,
  ../private/templates


defineNode:
  HScene(HNode)


proc newHScene*(tag: string = "HScene"): HSceneRef =
  ## Creates a new HScene
  defaultNode(HSceneRef)
