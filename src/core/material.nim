#[
  Provides shader materials
]#
when defined(vulkan):
  import
    ../thirdparty/vulkan
  
  const
    DefaultVertexCode* = ""
    DefaultFragmentCode* = ""
    DefaultTextureVertexCode* = """"""
    DefaultTextureFragmentCode* = """"""
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
    DefaultTextureVertexCode* = """"""
    DefaultTextureFragmentCode* = """"""
else:
  import
    ../app/app,
    ../thirdparty/webgl,
    ../thirdparty/webgl/consts
  
  const
    DefaultVertexCode* = """
      precision mediump float;

      attribute vec2 pos;
      attribute vec4 clr;
      uniform vec2 u_res;

      varying vec4 v_color;
      
      void main() {
        vec2 position = ((pos / u_res) * 2.0 - 1.0) * vec2(1, -1);
        gl_Position = vec4(position, 0, 1);
        v_color = clr;
      }"""
    DefaultFragmentCode* = """
      precision mediump float;

      varying vec4 v_color;

      void main() {
        gl_FragColor = v_color;
      }"""
    DefaultTextureVertexCode* = """
      precision mediump float;

      attribute vec2 uv;
      attribute vec2 pos;
      attribute vec4 clr;
      uniform vec2 u_res;

      varying vec2 v_tex_coords;
      varying vec4 v_color;
      varying vec2 v_res;
      
      void main() {
        vec2 position = ((pos / u_res) * 2.0 - 1.0) * vec2(1, -1);
        gl_Position = vec4(position, 0, 1);
        v_color = clr;
        v_res = u_res;
        v_tex_coords = uv;
      }"""
    DefaultTextureFragmentCode* = """
      precision mediump float;
      
      varying vec4 v_color;
      varying vec2 v_res;
      varying vec2 v_tex_coords;
      uniform sampler2D u_texture;
      
      void main() {
        gl_FragColor = texture2D(u_texture, v_tex_coords) * v_color;
      }"""


type
  ShaderMaterial* = ref object
    when defined(js):
      vertexCode*: cstring
      fragmentCode*: cstring
    else:
      vertexCode*: string
      fragmentCode*: string
    when defined(vulkan):
      discard
    elif not defined(js):
      program*: GLuint
      vertexShader: GLuint
      fragmentShader: GLuint
    else:
      program*: WebGLProgram
      vertexShader: WebGLShader
      fragmentShader: WebGLShader
    isCompiled: bool


proc newShaderMaterial*: ShaderMaterial =
  ## Creates a new shader material
  result = ShaderMaterial(vertexCode: DefaultVertexCode, fragmentCode: DefaultFragmentCode)
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


func isCompiled*(self: ShaderMaterial): bool = self.isCompiled


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

    glAttachShader(self.program, self.vertexShader)
    glAttachShader(self.program, self.fragmentShader)
    glLinkProgram(self.program)
  else:
    gl.shaderSource(self.vertexShader, self.vertexCode)
    gl.shaderSource(self.fragmentShader, self.fragmentCode)

    gl.compileShader(self.vertexShader)
    if not gl.getStatus(self.vertexShader):
      echo gl.getShaderInfoLog(self.vertexShader)
      echo self.vertexCode
    gl.compileShader(self.fragmentShader)
    if not gl.getStatus(self.fragmentShader):
      echo gl.getShaderInfoLog(self.fragmentShader)
      echo self.fragmentCode

    when defined(debug):
      {.emit: """
      let src = `gl`.getExtension('WEBGL_debug_shaders').getTranslatedShaderSource(`self`.`vertexShader`);
      console.log(src);
      src = `gl`.getExtension('WEBGL_debug_shaders').getTranslatedShaderSource(`self`.`fragmentShader`);
      console.log(src);
      """.}

    gl.attachShader(self.program, self.vertexShader)
    gl.attachShader(self.program, self.fragmentShader)

    gl.linkProgram(self.program)
    if not gl.getStatus(self.program):
      echo gl.getProgramInfoLog(self.program)
  self.isCompiled = true


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


proc unuse*(self: ShaderMaterial) =
  ## Use current program
  when defined(vulkan):
    discard
  elif not defined(js):
    glUseProgram(0)
  else:
    gl.useProgram(nil)
