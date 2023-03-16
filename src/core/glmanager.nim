#[
  Provides some utils for OpenGl
]#
import ./material

when not defined(js):
  import ../thirdparty/opengl
else:
  import
    ../thirdparty/webgl,
    ../thirdparty/webgl/consts,
    ../app/app


when not defined(js):
  proc emptyTexture2D*(internalFormat: GLenum, format: GLenum, w, h: GLsizei): GLuint =
    ## Creates an empty 2d texture and returns it
    var texture: Gluint

    glGenTextures(1, addr texture)
    glBindTexture(GL_TEXTURE_2D, texture)

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)

    glTexImage2D(GL_TEXTURE_2D, 0, internalFormat.GLint, w, h, 0, format, GL_UNSIGNED_BYTE, nil)

    glBindTexture(GL_TEXTURE_2D, 0)

    texture


  proc initFramebuffers*(colorTexture: GLuint, rbo: var GLuint, w, h: float): GLuint =
    ## Creates a new framebuffer object
    var fbo: GLuint

    glGenFramebuffers(1, addr fbo)
    glBindFramebuffer(GL_FRAMEBUFFER, fbo)

    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, colorTexture, 0)

    if glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE:
      return
    
    glClearColor(0f, 0f, 0f, 0f)
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glViewport(0, 0, w.GLsizei, h.GLsizei)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(0, w, 0, h, 0, 100f)
    glMatrixMode(GL_MODELVIEW)
    
    glGenRenderbuffers(1, addr rbo)
    glBindRenderbuffer(GL_RENDERBUFFER, rbo)
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, w.GLsizei, h.GLsizei)
    glBindRenderbuffer(GL_RENDERBUFFER, 0)
    glFramebufferRenderBuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo)

    glBindFramebuffer(GL_FRAMEBUFFER, 0)
    fbo
else:
  proc emptyTexture2D*(internalFormat: int, format: uint, w, h: int): WebGLTexture =
    ## Creates a new empty texture
    result = gl.createTexture()
    gl.bindTexture(TEXTURE_2D, result)
    gl.texParameterf(TEXTURE_2D, TEXTURE_MIN_FILTER, LINEAR.float)
    gl.texParameterf(TEXTURE_2D, TEXTURE_MAG_FILTER, LINEAR.float)

    gl.texParameterf(TEXTURE_2D, TEXTURE_WRAP_S, CLAMP_TO_EDGE.float)
    gl.texParameterf(TEXTURE_2D, TEXTURE_WRAP_T, CLAMP_TO_EDGE.float)
    gl.texImage2D(TEXTURE_2D, 0, internalFormat, w, h, 0, format, UNSIGNED_BYTE, nil)
    gl.bindTexture(TEXTURE_2D, nil)

  proc initFramebuffers*(colorTexture: WebGLTexture, rbo: var WebGLRenderbuffer, w, h: float): WebGLFramebuffer =
    ## Creates a new framebuffer object
    var fbo = gl.createFramebuffer()
    gl.bindFramebuffer(FRAMEBUFFER, fbo)

    gl.framebufferTexture2D(FRAMEBUFFER, COLOR_ATTACHMENT0, TEXTURE_2D, colorTexture, 0)
    
    gl.clearColor(0f, 0f, 0f, 0f)
    gl.clear(COLOR_BUFFER_BIT or DEPTH_BUFFER_BIT)
    gl.enable(BLEND)
    gl.blendFunc(SRC_ALPHA, ONE_MINUS_SRC_ALPHA)
    gl.viewport(0, 0, w.int, h.int)
    
    rbo = gl.createRenderBuffer()
    gl.bindRenderbuffer(RENDERBUFFER, rbo)
    gl.renderbufferStorage(RENDERBUFFER, DEPTH_STENCIL, w.int, h.int)
    gl.bindRenderbuffer(RENDERBUFFER, nil)
    gl.framebufferRenderBuffer(FRAMEBUFFER, DEPTH_STENCIL_ATTACHMENT, RENDERBUFFER, rbo)

    gl.bindFramebuffer(FRAMEBUFFER, nil)
    fbo
  
  proc drawQuad*(material: ShaderMaterial, x, y, w, h: float) =
    var
      vertices = [
      # x, y      r   g   b   a
        x+w, y+h, 1f, 0f, 1f, 1f,
        x+w, y,   1f, 1f, 0f, 1f,
        x,   y,   0f, 0f, 1f, 1f,
        x,   y+h, 0f, 1f, 1f, 1f,
      ]

    if not material.isCompiled:
      material.compile()
    material.use()

    var
      vertexBuffer = gl.createBuffer()
    gl.bindBuffer(ARRAY_BUFFER, vertexBuffer)
    gl.bufferData(ARRAY_BUFFER, vertices, STATIC_DRAW)

    var
      pos = gl.getAttribLocation(material.program, "pos")  # vec2
      clr = gl.getAttribLocation(material.program, "clr")  # vec4
      uRes = gl.getUniformLocation(material.program, "u_res")  # float
    
    gl.enableVertexAttribArray(pos)
    gl.enableVertexAttribArray(clr)
    gl.vertexAttribPointer(pos, 2, FLOAT, false, 6*4, 0)
    gl.vertexAttribPointer(clr, 4, FLOAT, false, 6*4, 2*4)

    gl.uniform2f(uRes, gl.canvas.width.float, gl.canvas.height.float)

    gl.drawArrays(TRIANGLE_FAN, 0, 4)

    material.unuse()
    gl.bindBuffer(ARRAY_BUFFER, nil)
    gl.deleteBuffer(vertexBuffer)
