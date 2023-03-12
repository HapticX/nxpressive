#[
  Provides some utils for OpenGl
]#
import ../thirdparty/opengl


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


proc initFramebuffers*(colorTexture, depthTexture: GLuint): GLuint =
  ## Creates a new framebuffer object
  var fbo: GLuint

  glGenFramebuffers(1, addr fbo)
  glBindFramebuffer(GL_FRAMEBUFFER, fbo)

  glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, colorTexture, 0)
  glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depthTexture, 0)

  if glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE:
    return

  glBindFramebuffer(GL_FRAMEBUFFER, 0)
  fbo
