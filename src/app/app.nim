#[
  Provides window behavior
]#
import
  os,
  unicode,
  strutils,
  ../core/core,
  ../core/vec2,
  ../core/input,
  ../core/exceptions,
  ../nodes/scene,
  ../thirdparty/sdl2/image,
  ../thirdparty/sdl2/joystick,
  ../thirdparty/sdl2,
  ./environment

when defined(vulkan):
  import
    ../thirdparty/vulkan,
    ../core/vulkan
else:
  import ../thirdparty/opengl



type
  App* = object
    when defined(vulkan):
      vkmanager: VulkanManager
    else:
      context: GlContextPtr
    current, main*: HSceneRef
    window: WindowPtr
    paused*: bool
    running: bool
    title: string
    w, h: cint
    env*: Environment
    scenes, scene_stack: seq[HSceneRef]


proc newApp*(title: string = "App", width: cint = 720, height: cint = 480): App =
  ## Initializes the new app with specified title and size
  once:
    # Set up SDL 2
    discard captureMouse(True32)
    discard sdl2.init(INIT_EVERYTHING)
  
    when defined(vulkan):
      # Initialize Vulkan
      if not defined(android) and not defined(ios) and not defined(js):
        vkPreload()
    elif not defined(android) and not defined(ios) and not defined(js):
      # Initialize OpenGL
      loadExtensions()
    when not defined(vulkan):
      # Set up GL attrs
      discard glSetAttribute(SDL_GL_DOUBLEBUFFER, 1)
      discard glSetAttribute(SDL_GL_GREEN_SIZE, 6)
      discard glSetAttribute(SDL_GL_RED_SIZE, 5)
      discard glSetAttribute(SDL_GL_BLUE_SIZE, 5)
  result = App(
    title: title,
    w: width,
    h: height,
    running: false,
    paused: false,
    env: newEnvironment(),
    scenes: @[],
    scene_stack: @[],
    current: nil,
    main: nil
  )
  when defined(vulkan):
    let flags = SDL_WINDOW_VULKAN
  else:
    let flags = SDL_WINDOW_OPENGL
  let window = createWindow(
    title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height,
    SDL_WINDOW_SHOWN or flags or SDL_WINDOW_RESIZABLE or SDL_WINDOW_ALLOW_HIGHDPI or
    SDL_WINDOW_FOREIGN or SDL_WINDOW_INPUT_FOCUS or SDL_WINDOW_MOUSE_FOCUS
  )
  result.window = window

  when defined(vulkan):
    result.vkmanager = initVulkan()
  else:
    result.context = window.glCreateContext()
    glShadeModel(GL_SMOOTH)
    glClear(GL_COLOR_BUFFER_BIT)
    glEnable(GL_COLOR_MATERIAL)
    glMaterialf(GL_FRONT, GL_SHININESS, 15)


proc reshape*(width, height: cint) =
  ## Computes an aspect ratio of the new window size
  ## `width` and `height` of current window
  when defined(vulkan):
    discard
  else:
    glViewport(0, 0, width, height)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glFrustumf(-width.float/2f, width.float/2f, -height.float/2f, height.float/2f, 1.5f, 20f)
    glMatrixMode(GL_MODELVIEW)


func title*(app: App): string =
  ## Returns app title
  app.title


func `title=`*(app: var App, new_title: string): string =
  ## Changes app title
  app.title = new_title
  app.window.setTitle(new_title)


func `icon=`*(app: var App, icon_path: cstring) =
  ## Changes app icon if available
  ## `icon_path` is path to icon
  let icon = cast[SurfacePtr](image.load(icon_path))
  app.window.setIcon(icon)


func hasScene*(app: App, tag: string): bool =
  ## Returns true when app contains scene with `tag`
  for scene in app.scenes:
    if scene.tag == tag:
      return true
  false


proc goTo*(app: var App, tag: string) =
  ## Goes to available scene
  for s in app.scenes:
    if s.tag == tag:
      app.scene_stack.add(s)
      app.current.exit()
      app.current = s
      app.current.enter()
      break


proc goBack*(app: var App) =
  ## Goes back in scene stack
  assert app.scene_stack.len > 0
  discard app.scene_stack.pop()
  app.current.exit()
  app.current = app.scene_stack[^1]
  app.current.enter()


func clearSceneStack*(app: var App) =
  ## Clears scene stack and puts current scene into stack
  app.scene_stack = @[app.current]


func size*(app: App): Vec2 =
  ## Returns current window size
  Vec2(x: app.w.float, y: app.h.float)


proc resize*(app: var App, w: cint, h: cint) =
  ## Resizes window
  ## `w` - new width
  ## `h` - new height
  app.window.setSize(w, h)
  app.w = w
  app.h = h
  reshape(w, h)


proc resize*(app: var App, new_size: Vec2) =
  ## Resizes window
  ## `new_size` - Vec2 size repr
  app.window.setSize(new_size.x.cint, new_size.y.cint)
  app.w = new_size.x.cint
  app.h = new_size.y.cint
  reshape(app.w, app.h)


func quit*(app: var App) =
  ## Quits from app
  app.running = false


template check(event, condition, conditionelif: untyped): untyped =
  ## Checks input event and changes press state
  ## `event` - InputEventType
  ## `condition` - condition when press state should be 2
  ## `conditionelif` - condition when press state should be 1
  press_state =
    if last_event.kind == `event` and `condition`:
      2
    elif `conditionelif`:
      1
    else:
      0

{.push cdecl.}
proc keyboard(app: App, key: cint, pressed: bool) =
  ## Notify input system about keyboard event
  ## `key` - key code
  check(InputEventType.Keyboard, last_event.pressed, true)
  let k = $Rune(key)
  if pressed:
    pressed_keys.add(key)
  else:
    for i in pressed_keys.low..pressed_keys.high:
      if pressed_keys[i] == key:
        pressed_keys.del(i)
        break
  last_event.kind = InputEventType.Keyboard
  last_event.key = k
  last_event.key_int = key
  last_event.pressed = pressed

proc textinput(app: App, ev: TextInputEventPtr) =
  ## Notify input system about keyboard event
  last_event.kind = InputEventType.Text
  last_event.key = toRunes(join(ev.text))[0].toUTF8()

proc mousebutton(app: App, btn, x, y: cint, pressed: bool) =
  ## Notify input system about mouse button event
  check(InputEventType.Mouse, last_event.pressed and pressed, pressed)
  last_event.kind = InputEventType.Mouse
  last_event.pressed = pressed
  last_event.x = x.float
  last_event.y = y.float

proc wheel(app: App, x, y: cint) =
  ## Notify input system about mouse wheel event
  check(InputEventType.Wheel, false, false)
  last_event.kind = InputEventType.Wheel
  last_event.xrel = x.float
  last_event.yrel = y.float

proc motion(app: App, x, y, xrel, yrel: cint) =
  ## Notify input system about mouse motion event
  last_event.kind = InputEventType.Motion
  last_event.x = x.float
  last_event.y = y.float
  last_event.xrel = xrel.float
  last_event.yrel = yrel.float

proc joyaxismotion(app: App, axis: uint8, which: int, val: int16) =
  ## Notify input system about joystick event
  last_event.kind = InputEventType.JAxisMotion
  last_event.axis = axis
  last_event.val = val.float

proc joyhatmotion(app: App, axis: uint8, which: int) =
  ## Notify input system about joystick event
  last_event.kind = InputEventType.JHatMotion
  last_event.axis = axis

proc joybutton(app: App, button_index: cint, pressed: bool) =
  ## Notify input system about joystick event
  check(InputEventType.JButton, last_event.pressed and pressed, pressed)
  last_event.kind = InputEventType.JButton
  last_event.button_index = button_index
  last_event.pressed = pressed
{.pop.}


proc handleEvent(app: var App) =
  ## Handles SDL2 events
  # Handle joysticks
  var joystick: JoystickPtr
  discard joystickEventState(SDL_ENABLE)
  joystick = joystickOpen(0)

  # Handle events
  var event = defaultEvent

  while sdl2.pollEvent(event):
    case event.kind
    of QuitEvent:
      app.running = false
    of KeyDown:
      keyboard(app, evKeyboard(event).keysym.sym, true)
    of KeyUp:
      keyboard(app, evKeyboard(event).keysym.sym, false)
    of TextInput:
      textinput(app, evTextInput(event))
    of MouseButtonDown:
      let ev = evMouseButton(event)
      mousebutton(app, ev.button.cint, ev.x, ev.y, true)
    of MouseButtonUp:
      let ev = evMouseButton(event)
      mousebutton(app, ev.button.cint, ev.x, ev.y, false)
    of MouseWheel:
      let ev = evMouseWheel(event)
      wheel(app, ev.x, ev.y)
    of MouseMotion:
      let ev = evMouseMotion(event)
      motion(app, ev.x, ev.y, ev.xrel, ev.yrel)
    of JoyAxisMotion:
      let ev = EvJoyAxis(event)
      joyaxismotion(app, ev.axis, ev.which, ev.value)
    of JoyButtonDown:
      let ev = EvJoyButton(event)
      joybutton(app, ev.button.cint, true)
    of JoyButtonUp:
      let ev = EvJoyButton(event)
      joybutton(app, ev.button.cint, false)
    of JoyHatMotion:
      let ev = EvJoyHat(event)
      joyhatmotion(app, ev.hat, ev.which)
    else:
      discard


proc display(app: App) =
  ## Displays current scene
  let bg = app.env.background_color
  when defined(vulkan):
    app.vkmanager.display()
  else:
    # Default color
    glClearColor(bg.r, bg.g, bg.b, bg.a)
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glLoadIdentity()

  # Draw current scene
  app.current.draw()

  when defined(vulkan):
    discard
  else:
    glFlush()
    app.window.glSwapWindow()
  # Framerate
  when defined(js):
    jsSleep(app.env.delay.int)
  else:
    os.sleep(app.env.delay.int)


proc run*(app: var App) =
  ## Runs app and launches the main scene
  if isNil(app.main):
    raise newException(MainSceneNotDefinedDefect, "Main scene not defined!")
  app.current = app.main
  app.running = true
  app.scene_stack.add(app.current)
  app.current.enter()

  when defined(debug):
    echo "App started"
  
  # Main app loop
  while app.running:
    app.handleEvent()
    app.display()

  app.current.exit()

  when defined(vulkan):
    app.vkmanager.cleanUp()
  else:
    glDeleteContext(app.context)
  destroy(app.window)
  sdl2.quit()
