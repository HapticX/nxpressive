#[
  Provides working with Basis
]#
import
  strformat,
  vec3


type
  Basis* = object
    x*, y*, z*: Vec3


const
  Zero* = Basis(
      x: Vec3(x: 0f, y: 0f, z: 0f),
      y: Vec3(x: 0f, y: 0f, z: 0f),
      z: Vec3(x: 0f, y: 0f, z: 0f)
    )
  One* = Basis(
      x: Vec3(x: 1f, y: 1f, z: 1f),
      y: Vec3(x: 1f, y: 1f, z: 1f),
      z: Vec3(x: 1f, y: 1f, z: 1f)
    )
  Diagonal* = Basis(
      x: Vec3(x: 1f, y: 0f, z: 0f),
      y: Vec3(x: 0f, y: 1f, z: 0f),
      z: Vec3(x: 0f, y: 0f, z: 1f)
    )
  SecondDiagonal* = Basis(
      x: Vec3(x: 0f, y: 0f, z: 1f),
      y: Vec3(x: 0f, y: 1f, z: 0f),
      z: Vec3(x: 1f, y: 0f, z: 0f)
    )


func newBasis*: Basis =
  ## Creates a new zero basis
  Basis(
    x: Vec3(x: 0f, y: 0f, z: 0f),
    y: Vec3(x: 0f, y: 0f, z: 0f),
    z: Vec3(x: 0f, y: 0f, z: 0f)
  )

func newBasis*(val: float): Basis =
  ## Creates a new basis with val
  Basis(
    x: Vec3(x: val, y: val, z: val),
    y: Vec3(x: val, y: val, z: val),
    z: Vec3(x: val, y: val, z: val)
  )

func newBasis*(x, y, z: float): Basis =
  ## Creates a new basis with xyz values
  Basis(
    x: Vec3(x: x, y: y, z: z),
    y: Vec3(x: x, y: y, z: z),
    z: Vec3(x: x, y: y, z: z)
  )

func newBasis*(x1, y1, z1, x2, y2, z2, x3, y3, z3: float): Basis =
  ## Creates a new basis
  Basis(
    x: Vec3(x: x1, y: y1, z: z1),
    y: Vec3(x: x2, y: y2, z: z2),
    z: Vec3(x: x3, y: y3, z: z3)
  )



# ---=== Operators ===--- #
func `$`*(a: Basis): string =
  fmt"basis({a.x}, {a.y}, {a.z})"

func pretty*(a: Basis): string =
  fmt"""basis(
  {a.x.x}, {a.x.y}, {a.x.z}
  {a.y.x}, {a.y.y}, {a.y.z}
  {a.z.x}, {a.z.y}, {a.z.z}
)"""
