#[
  Provides window behavior
]#
import
  os,
  ../core/vec2,
  ../core/exceptions,
  ../nodes/scene,
  ../thirdparty/sdl2,
  ../thirdparty/opengl,
  ./environment


type
  App* = object
    scenes*: seq[HSceneRef]
    current*, main*: HSceneRef
    context: GlContextPtr
    window: WindowPtr
    paused*: bool
    running: bool
    title: string
    w, h: cint
    env*: Environment


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


func `title=`*(app: var App): string =
  ## Changes app title


func size*(app: App): Vec2 =
  ## Returns current window size
  Vec2(x: app.w.float, y: app.h.float)


func resize*(app: var App, w: cint, h: cint) =
  ## Resizes window


func resize*(app: var App, new_size: Vec2) =
  ## Resizes window


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

  app.current.draw()

  glFlush()
  app.window.glSwapWindow()
  os.sleep(app.env.delay.int)


proc run*(app: var App) =
  ## Runs app and launches the main scene
  if isNil(app.main):
    raise newException(MainSceneNotDefinedDefect, "Main scene not defined!")
  app.current = app.main
  app.running = true

  when defined(debug):
    echo "App started"
  
  while app.running:
    app.display()

  glDeleteContext(app.context)
  destroy(app.window)
  sdl2.quit()
