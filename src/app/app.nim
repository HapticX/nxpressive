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
  ../thirdparty/sdl2,
  ../thirdparty/opengl,
  ./environment


type
  App* = object
    current, main*: HSceneRef
    context: GlContextPtr
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
    # Init SDL2 and OpenGL
    when not defined(android) and not defined(ios) and not defined(useGlew) and not defined(js):
      loadExtensions()
      discard captureMouse(True32)
    discard init(INIT_EVERYTHING)
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
  let window = createWindow(
    title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height,
    SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL or SDL_WINDOW_RESIZABLE or SDL_WINDOW_ALLOW_HIGHDPI or
    SDL_WINDOW_FOREIGN or SDL_WINDOW_INPUT_FOCUS or SDL_WINDOW_MOUSE_FOCUS
  )
  result.window = window
  result.context = window.glCreateContext()

  glShadeModel(GL_SMOOTH)
  glClear(GL_COLOR_BUFFER_BIT)
  glEnable(GL_COLOR_MATERIAL)
  glMaterialf(GL_FRONT, GL_SHININESS, 15)


proc reshape*(width, height: cint) =
  ## Computes an aspect ratio of the new window size
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


func goTo*(app: var App, tag: string) =
  ## Goes to available scene
  for s in app.scenes:
    if s.tag == tag:
      app.scene_stack.add(s)
      app.current = s
      break


func goBack*(app: var App) =
  ## Goes back in scene stack
  assert app.scene_stack.len > 0
  discard app.scene_stack.pop()
  app.current = app.scene_stack[^1]


func clearSceneStack*(app: var App) =
  ## Clears scene stack and puts current scene into stack
  app.scene_stack = @[app.current]


func size*(app: App): Vec2 =
  ## Returns current window size
  Vec2(x: app.w.float, y: app.h.float)


proc resize*(app: var App, w: cint, h: cint) =
  ## Resizes window
  app.window.setSize(w, h)
  app.w = w
  app.h = h
  reshape(w, h)


proc resize*(app: var App, new_size: Vec2) =
  ## Resizes window
  app.window.setSize(new_size.x.cint, new_size.y.cint)
  app.w = new_size.x.cint
  app.h = new_size.y.cint
  reshape(app.w, app.h)


func quit*(app: var App) =
  ## Quits from app
  app.running = false


proc display(app: App) =
  ## Displays current scene
  let bg = app.env.background_color
  glClearColor(bg.r, bg.g, bg.b, bg.a)
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
  glEnable(GL_BLEND)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
  glLoadIdentity()

  app.current.draw()

  glFlush()
  app.window.glSwapWindow()
  when defined(js):
    jsSleep(app.env.delay.int)
  else:
    os.sleep(app.env.delay.int)


template check(event, condition, conditionelif: untyped): untyped =
  if last_event.kind == `event` and `condition`:
    press_state = 2
  elif `conditionelif`:
    press_state = 1
  else:
    press_state = 0

{.push cdecl.}
proc keyboard(app: App, key: cint, pressed: bool) =
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
  last_event.kind = InputEventType.Text
  last_event.key = toRunes(join(ev.text))[0].toUTF8()
{.pop.}


proc handleEvent(app: var App) =
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
    else:
      discard


proc run*(app: var App) =
  ## Runs app and launches the main scene
  if isNil(app.main):
    raise newException(MainSceneNotDefinedDefect, "Main scene not defined!")
  app.current = app.main
  app.running = true
  app.scene_stack.add(app.current)

  when defined(debug):
    echo "App started"
  
  # Main app loop
  while app.running:
    app.handleEvent()
    app.display()

  glDeleteContext(app.context)
  destroy(app.window)
  sdl2.quit()
