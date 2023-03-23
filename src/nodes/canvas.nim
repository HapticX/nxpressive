#[
  Provides Canvas behavior
]#
import
  ./node,
  ../private/templates,
  ../core/enums,
  ../core/color,
  ../core/input,
  ../core/material


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
    material*: ShaderMaterial
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
  result.material = newShaderMaterial()
  result.material.fragmentCode = DefaultTextureFragmentCode
  result.material.vertexCode = DefaultTextureVertexCode
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
  self.material.destroy()
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
    drawTexQuad(self.material, self.tex, self.x, self.y, self.w, self.h, WhiteClr)
    # drawQuad(self.material, self.x, self.y, self.w, self.h, WhiteClr)

  when defined(vulkan):
    discard
  elif not defined(js):
    ## Unbind framebuffer and texture
    glBindTexture(GL_TEXTURE_2D, 0)
    glPopMatrix()
  else:
    discard


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
    gl.viewport(0, 0, self.w.int, self.h.int)
    gl.scissor(0, 0, (self.w*2.0).int, (self.h*2.0).int)
    drawQuad(newShaderMaterial(), x, y, w, h, clr)
    gl.bindFramebuffer(FRAMEBUFFER, nil)
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)
    gl.scissor(0, 0, gl.canvas.width*2, gl.canvas.height*2)
