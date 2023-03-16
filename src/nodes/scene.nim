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


method draw*(self: HSceneRef, w, h: float) =
  ## Draws all children
  procCall self.HNodeRef.draw(w, h)
  self.on_process()
  for node in self.iter():
    node.draw(w, h)


method handleEvent*(self: HSceneRef, event: InputEvent) =
  ## Handles event
  self.on_input(event)
  for node in self.iter():
    node.on_input(event)
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
