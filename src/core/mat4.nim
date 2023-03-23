#[
  Provides Matrix4 behavior
]#

type
  Mat4* = array[16, float32]


func newMat4*: Mat4 =
  let x: Mat4 = [0f,0,0,0,
                  0,0,0,0,
                  0,0,0,0,
                  0,0,0,0]
  x


func `[][]`*(self: Mat4, x, y: int): float =
  self[y*4 + x]


func `[][]=`*(self: var Mat4, x, y: int, val: float) =
  self[y*4 + x] = val
