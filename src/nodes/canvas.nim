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
    ../thirdparty/opengl


type
  HCanvasRef* = ref HCanvas
  HCanvas* = object of HNode
    when defined(vulkan):
      discard
    else:
      fbuffer: GLuint
      ftexture: GLuint


proc newHCanvas*(tag: string = "HCanvas"): HCanvasRef =
  ## Creates a new HCanvas
  defaultNode(HCanvasRef)
  when defined(vulkan):
    discard
  else:
    ## Generates framebuffer and texture
    glGenFramebuffers(1, addr result.fbuffer)
    glGenTextures(1, addr result.ftexture)


method destroy*(self: HCanvasRef) =
  ## Destroys canvas
  when defined(vulkan):
    discard
  else:
    ## Deletes framebuffer and texture
    glDeleteFramebuffers(1, addr self.fbuffer)
    glDeleteTextures(1, addr self.ftexture)
  procCall self.HNodeRef.destroy()


method draw*(self: HCanvasRef) =
  ## Draws canvas
  procCall self.HNodeRef.draw()
  when defined(vulkan):
    discard
  else:
    ## Bind framebuffer and texture
    glBindFramebuffer(GL_FRAMEBUFFER, self.fbuffer)
    glBindTexture(GL_TEXTURE_2D, self.ftexture)

  when defined(vulkan):
    discard
  else:
    ## Unbind framebuffer and texture
    glBindFramebuffer(GL_FRAMEBUFFER, 0)
    glBindTexture(GL_TEXTURE_2D, 0)
