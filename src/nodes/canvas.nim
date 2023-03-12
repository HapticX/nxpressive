#[
  Provides Canvas behavior
]#
import
  ./node,
  ../private/templates,
  ../core/enums


when defined(vulkan):
  import
    ../thirdparty/vulkan,
    ../core/vkmanager
else:
  import
    ../thirdparty/opengl,
    ../core/glmanager


type
  HCanvasRef* = ref HCanvas
  HCanvas* = object of HNode
    x*, y*: float
    w*, h*: float
    when defined(vulkan):
      discard
    else:
      fbo: GLuint  # Framebuffer object
      cto: GLuint  # color texture
      dto: Gluint  # depth texture


proc newHCanvas*(tag: string = "HCanvas"): HCanvasRef =
  ## Creates a new HCanvas
  defaultNode(HCanvasRef)
  result.x = 0f
  result.y = 0f
  result.w = 512f
  result.h = 512f
  when defined(vulkan):
    discard
  else:
    ## Generates framebuffers and textures
    result.cto = emptyTexture2D(GL_RGBA8, GL_RGB, result.w.Glsizei, result.h.Glsizei)
    result.dto = emptyTexture2D(GL_DEPTH_COMPONENT24, GL_DEPTH_COMPONENT, result.w.Glsizei, result.h.Glsizei)
    result.fbo = initFramebuffers(result.cto, result.dto)


method destroy*(self: HCanvasRef) =
  ## Destroys canvas
  when defined(vulkan):
    discard
  else:
    ## Deletes framebuffer and texture
    glDeleteFramebuffers(1, addr self.fbo)
    glDeleteTextures(1, addr self.cto)
    glDeleteTextures(1, addr self.dto)
  procCall self.HNodeRef.destroy()


method draw*(self: HCanvasRef) =
  ## Draws canvas
  procCall self.HNodeRef.draw()
  when defined(vulkan):
    discard
  else:
    ## Bind framebuffer and texture
    # glEnable(GL_TEXTURE_2D)
    # glBindFramebuffer(GL_FRAMEBUFFER, self.fbo)
    # glBindTexture(GL_TEXTURE_2D, self.cto)
    glPushMatrix()
    glTranslatef(self.x, self.y, 0f)

    glBegin(GL_QUADS)
    glColor4f(1f, 1f, 1f, 1f)
    glVertex2f(0, 0)
    glVertex2f(self.w, 0)
    glVertex2f(self.w, self.h)
    glVertex2f(0, self.h)
    glEnd()

  when defined(vulkan):
    discard
  else:
    ## Unbind framebuffer and texture
    # glBindFramebuffer(GL_FRAMEBUFFER, 0)
    # glBindTexture(GL_TEXTURE_2D, 0)
    # glDisable(GL_TEXTURE_2D)
    glPopMatrix()
