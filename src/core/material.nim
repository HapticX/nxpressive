#[
  Provides shader materials
]#
when defined(vulkan):
  import
    ../thirdparty/vulkan
elif not defined(js):
  import
    ../thirdparty/opengl
  
  const
    DefaultVertexCode* = """
    void main()
    {
      gl_Position = ftransform();
    }"""
    DefaultFragmentCode* = """
    void main()
    {
      gl_FragColor = vec4(1,1,1,1);
    }"""
else:
  import
    ../app/app,
    ../thirdparty/webgl,
    ../thirdparty/webgl/consts
  
  const
    DefaultVertexCode* = """
    attribute vec2 aVertexPosition;
    varying vec2 vTexCoord;
    void main() {
      vTexCoord = aVertexPosition;
      gl_Position = vec4(aVertexPosition, 0, 1);
    }
    """
    DefaultFragmentShader* = """
    precision mediump float;
    varying vec2 vTexCoord;
    void main() {
      gl_FragColor = vec4(vTexCoord, 0, 1);
    }"""


type
  ShaderMaterial* = ref object
    vertexCode*: string
    fragmentCode*: string
    when defined(vulkan):
      discard
    elif not defined(js):
      program: GLuint
      vertexShader: GLuint
      fragmentShader: GLuint
    else:
      program: WebGLProgram
      vertexShader: WebGLShader
      fragmentShader: WebGLShader


proc newShaderMaterial*: ShaderMaterial =
  ## Creates a new shader material
  result = ShaderMaterial(vertexCode: DefaultVertexCode, fragmentCode: DefaultVertexCode)
  when defined(vulkan):
    discard
  elif not defined(js):
    result.program = glCreateProgram()
    result.vertexShader = glCreateShader(GL_VERTEX_SHADER)
    result.fragmentShader = glCreateShader(GL_FRAGMENT_SHADER)
  else:
    result.program = gl.createProgram()
    result.vertexShader = gl.createShader(VERTEX_SHADER)
    result.fragmentShader = gl.createShader(FRAGMENT_SHADER)


proc compile*(self: ShaderMaterial) =
  ## Compiles shaders
  when defined(vulkan):
    discard
  elif not defined(js):
    var
      vertexSource = allocCStringArray([self.vertexCode])
      fragmentSource = allocCStringArray([self.fragmentCode])
    glShaderSource(self.vertexShader, 1, vertexSource, nil)
    glShaderSource(self.fragmentShader, 1, fragmentSource, nil)

    glCompileShader(self.vertexShader)
    glCompileShader(self.fragmentShader)
    # free memory
    deallocCStringArray(vertexSource)
    deallocCStringArray(fragmentSource)
  else:
    gl.shaderSource(self.vertexShader, self.vertexCode)
    gl.shaderSource(self.fragmentShader, self.fragmentCode)

    gl.compileShader(self.vertexShader)
    gl.compileShader(self.fragmentShader)


proc link*(self: ShaderMaterial) =
  ## Linking shaders to program
  when defined(vulkan):
    discard
  elif not defined(js):
    glAttachShader(self.program, self.vertexShader)
    glAttachShader(self.program, self.fragmentShader)
    glLinkProgram(self.program)

    glDeleteShader(self.vertexShader)
    glDeleteShader(self.fragmentShader)
  else:
    gl.attachShader(self.program, self.vertexShader)
    gl.attachShader(self.program, self.fragmentShader)
    gl.linkProgram(self.program)

    gl.deleteShader(self.vertexShader)
    gl.deleteShader(self.fragmentShader)


proc destroy*(self: ShaderMaterial) =
  ## Destroys shader program
  when defined(vulkan):
    discard
  elif not defined(js):
    glDeleteProgram(self.program)
  else:
    gl.deleteProgram(self.program)


proc use*(self: ShaderMaterial) =
  ## Use current program
  when defined(vulkan):
    discard
  elif not defined(js):
    glUseProgram(self.program)
  else:
    gl.useProgram(self.program)
