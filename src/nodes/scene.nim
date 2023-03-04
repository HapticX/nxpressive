#[
  Provides Scene behavior
]#
import
  ./node,
  ../core/hmacros,
  ../core/input,
  ../core/enums,
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
  procCall self.HNodeRef.draw()
  for node in self.iter():
    node.draw()


method handleEvent*(self: HSceneRef, event: InputEvent) =
  ## Handles event
  for node in self.iter():
    node.handleEvent(event)


proc enter*(scene: HSceneRef) =
  ## Enters in scene and calls `on_enter` callback
  scene.on_enter()
  for node in scene.iter():
    node.on_enter()
    node.is_ready = true
  scene.is_ready = true


proc exit*(scene: HSceneRef) =
  ## Exit from scene and calls `on_exit` callback
  scene.on_exit()
  for node in scene.iter():
    node.is_ready = false
  scene.is_ready = false
