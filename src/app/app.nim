#[
  Provides window behavior
]#
import
  ../core/vec2,
  ../nodes/scene,
  ../thirdparty/sdl2,
  ../thirdparty/opengl,
  ./environment


type
  App* = object
    scenes*: seq[HSceneRef]
    current*: HSceneRef
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
    when not defined(android) and not defined(ios) and not defined(useGlew) and not defined(js):
      loadExtensions()
      discard captureMouse(True32)
    discard init(INIT_EVERYTHING)
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
    env: newEnvironment()
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


func title*(app: App): string =
  ## Returns app title
  app.title


func `title=`*(app: App): string =
  ## Changes app title


func size*(app: App): Vec2 =
  ## Returns current window size
  Vec2(x: app.w.float, y: app.h.float)


func resize*(app: App, w: cint, h: cint) =
  ## Resizes window


func resize*(app: App, new_size: Vec2) =
  ## Resizes window
