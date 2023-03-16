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
  # result.material.fragmentCode = DefaultTextureFragmentCode
  # result.material.vertexCode = DefaultTextureVertexCode
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
    gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)
    gl.clearColor(0f, 0f, 0f, 1f)
    gl.clear(COLOR_BUFFER_BIT or DEPTH_BUFFER_BIT)
    # drawQuad(self.material, 0, 0, 1f, 1f)
    drawQuad(self.material, -0.5f, -0.5f, 0.5f, 0.5f)
    # drawQuad(self.material, -500f, -500f, 500f, 500f)

  when defined(vulkan):
    discard
  elif not defined(js):
    ## Unbind framebuffer and texture
    glBindTexture(GL_TEXTURE_2D, 0)
    glPopMatrix()
  else:
    # self.material.unuse()
    gl.bindBuffer(ARRAY_BUFFER, nil)
    # gl.deleteBuffer(buffer)
    gl.bindTexture(TEXTURE_2D, nil)


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
    # gl.viewport(0, 0, self.w.int, self.h.int)
    gl.clearColor(1f, 1f, 1f, 1f)
    gl.clear(COLOR_BUFFER_BIT or DEPTH_BUFFER_BIT)
    var
      vertices = [
      # position  color
        x,   y,   clr.r, clr.g, clr.b, clr.a,
        x+w, y+h, clr.r, clr.g, clr.b, clr.a,
        x+w, y+h, clr.r, clr.g, clr.b, clr.a,
        x,   y,   clr.r, clr.g, clr.b, clr.a
      ]
      verticesBuffer = gl.createBuffer()
      material = newShaderMaterial()
    
    gl.bindBuffer(ARRAY_BUFFER, verticesBuffer)
    gl.bufferData(ARRAY_BUFFER, vertices, STATIC_DRAW)

    material.compile()
    material.use()

    var
      a_position = gl.getAttribLocation(material.program, "pos")
      a_color = gl.getAttribLocation(material.program, "clr")

    gl.enableVertexAttribArray(a_position)
    gl.enableVertexAttribArray(a_color)

    gl.vertexAttribPointer(a_position, 2, FLOAT, false, 20, 0)
    gl.vertexAttribPointer(a_color, 3, FLOAT, false, 20, 8)

    gl.drawArrays(TRIANGLE_FAN, 0, 4)

    material.unuse()
    gl.bindBuffer(ARRAY_BUFFER, nil)
    gl.deleteBuffer(verticesBuffer)
    gl.bindFramebuffer(FRAMEBUFFER, nil)
    # gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)
