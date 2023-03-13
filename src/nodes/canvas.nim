#[
  Provides Canvas behavior
]#
import
  ./node,
  ../private/templates,
  ../core/enums,
  ../core/color


when defined(vulkan):
  import
    ../thirdparty/vulkan,
    ../core/vkmanager
elif not defined(js):
  import
    ../thirdparty/opengl,
    ../core/glmanager
else:
  import
    ../thirdparty/webgl,
    ../thirdparty/webgl/consts,
    ../core/glmanager,
    ../app/app


type
  HCanvasRef* = ref HCanvas
  HCanvas* = object of HNode
    x*, y*: float
    w*, h*: float
    screenw*, screenh*: float
    when defined(vulkan):
      discard
    elif not defined(js):
      fbo: GLuint  # Framebuffer object
      rbo: GLuint  # Renderbuffer object
      tex: GLuint  # color texture
    else:
      fbo: WebGLFramebuffer
      rbo: WebGLRenderbuffer
      tex: WebGLTexture


proc newHCanvas*(tag: string = "HCanvas"): HCanvasRef =
  ## Creates a new HCanvas
  defaultNode(HCanvasRef)
  result.x = 0f
  result.y = 0f
  result.w = 512f
  result.h = 512f
  when defined(vulkan):
    discard
  elif not defined(js):
    ## Generates framebuffers and textures
    result.tex = emptyTexture2D(GL_RGBA, GL_RGBA, result.w.Glsizei, result.h.Glsizei)
    result.fbo = initFramebuffers(result.tex, result.rbo, result.w, result.h)
  else:
    result.tex = emptyTexture2D(RGBA.int, RGBA.uint, result.w.int, result.h.int)
    result.fbo = initFramebuffers(result.tex, result.rbo, result.w, result.h)


method destroy*(self: HCanvasRef) =
  ## Destroys canvas
  when defined(vulkan):
    discard
  elif not defined(js):
    ## Deletes framebuffer and texture
    glDeleteFramebuffers(1, addr self.fbo)
    glDeleteRenderbuffers(1, addr self.rbo)
    glDeleteTextures(1, addr self.tex)
  else:
    gl.deleteFramebuffer(self.fbo)
    gl.deleteRenderbuffer(self.rbo)
    gl.deleteTexture(self.tex)
  procCall self.HNodeRef.destroy()


method draw*(self: HCanvasRef, w, h: float) =
  ## Draws canvas
  procCall self.HNodeRef.draw(w, h)
  self.screenh = h
  self.screenw = w
  when defined(vulkan):
    discard
  elif not defined(js):
    ## Bind framebuffer and texture
    glBindTexture(GL_TEXTURE_2D, self.tex)
    glPushMatrix()
    glTranslatef(self.x, self.y, 0f)

    glEnable(GL_TEXTURE_2D)
    glBegin(GL_QUADS)
    glColor4f(1f, 1f, 1f, 1f)
    glTexCoord2f(0f, 0f)
    glVertex2f(0, 0)
    glTexCoord2f(1f, 0f)
    glVertex2f(self.w, 0)
    glTexCoord2f(1f, 1f)
    glVertex2f(self.w, self.h)
    glTexCoord2f(0f, 1f)
    glVertex2f(0, self.h)
    glEnd()
    glDisable(GL_TEXTURE_2D)
  else:
    gl.bindFramebuffer(FRAMEBUFFER, self.fbo)
    gl.viewport(0, 0, self.w.int, self.h.int)

  when defined(vulkan):
    discard
  elif not defined(js):
    ## Unbind framebuffer and texture
    glBindTexture(GL_TEXTURE_2D, 0)
    glPopMatrix()
  else:
    gl.bindFramebuffer(FRAMEBUFFER, nil)
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)


proc drawRect*(self: HCanvasRef, x, y, w, h: float, clr: Color) =
  ## Draws rect at `x`,`y` with size `w`,`h`.
  when defined(vulkan):
    discard
  elif not defined(js):
    glBindFramebuffer(GL_FRAMEBUFFER, self.fbo)
    glColor4f(clr.r, clr.g, clr.b, clr.a)
    glRectf(x, y, x+w, y+h)
    glBindFramebuffer(GL_FRAMEBUFFER, 0)
  else:
    gl.bindFramebuffer(FRAMEBUFFER, self.fbo)
    gl.blendColor(clr.r, clr.g, clr.b, clr.a)
    let
      vertices = gl.createBuffer()
      indices = [3, 2, 1, 3, 1, 0]
      vertex = gl.createShader(VERTEX_SHADER)
      fragment = gl.createShader(FRAGMENT_SHADER)
      program = gl.createProgram()
    gl.shaderSource(vertex, vertexShader)
    gl.shaderSource(fragment, fragTexShader)
    gl.compileShader(vertex)
    gl.compileShader(fragment)

    gl.attachShader(program, vertex)
    gl.attachShader(program, fragment)

    gl.linkProgram(program)

    gl.bindFramebuffer(FRAMEBUFFER, nil)
