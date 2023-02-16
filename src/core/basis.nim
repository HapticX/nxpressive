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
  BasisZero* = Basis(
      x: Vec3(x: 0f, y: 0f, z: 0f),
      y: Vec3(x: 0f, y: 0f, z: 0f),
      z: Vec3(x: 0f, y: 0f, z: 0f)
    )
  BasisOne* = Basis(
      x: Vec3(x: 1f, y: 1f, z: 1f),
      y: Vec3(x: 1f, y: 1f, z: 1f),
      z: Vec3(x: 1f, y: 1f, z: 1f)
    )
  BasisDiagonal* = Basis(
      x: Vec3(x: 1f, y: 0f, z: 0f),
      y: Vec3(x: 0f, y: 1f, z: 0f),
      z: Vec3(x: 0f, y: 0f, z: 1f)
    )
  BasisSecondDiagonal* = Basis(
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

func `[]`*(a: Basis, index: int): Vec3 =
  if index == 0:
    a.x
  elif index == 1:
    a.y
  elif index == 2:
    a.z
  else:
    raise newException(IndexError, fmt"{index} is out of bounds")


template provideOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Basis): Basis {.inline.} =
    Basis(x: `op`(a.x, b.x), y: `op`(a.y, b.y), z: `op`(a.z, b.z))
  func `operatorFunc`*(a: float, b: Basis): Basis {.inline.} =
    Basis(x: `op`(a, b.x), y: `op`(a, b.y), z: `op`(a, b.z))
  func `operatorFunc`*(a: Basis, b: float): Basis {.inline.} =
    Basis(x: `op`(a.x, b), y: `op`(a.y, b), z: `op`(a.z, b))
  func `operatorFunc`*(a: Vec3, b: Basis): Basis {.inline.} =
    Basis(x: `op`(a.x, b.x), y: `op`(a.y, b.y), z: `op`(a.z, b.z))
  func `operatorFunc`*(a: Basis, b: Vec3): Basis {.inline.} =
    Basis(x: `op`(a.x, b.x), y: `op`(a.y, b.y), z: `op`(a.z, b.z))

template provideBinOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Basis): bool {.inline.} =
    `op`(a.x, b.x) and `op`(a.y, b.y) and `op`(a.z, b.z)


provideOperator(`+`, `+`)
provideOperator(`-`, `-`)
provideOperator(`/`, `/`)
provideOperator(`*`, `*`)

provideBinOperator(`==`, `==`)
provideBinOperator(`!=`, `!=`)
provideBinOperator(`>`, `>`)
provideBinOperator(`<`, `<`)


# ---=== Methods ===--- #
func determinant*(a: Basis): float =
  ## Calculates Basis determinant
  (
    a[0][0]*a[1][1]*a[2][2] + a[1][0]*a[2][1]*a[0][2] + a[0][1]*a[1][2]*a[2][0] -
    a[0][2]*a[1][1]*a[2][0] - a[0][0]*a[1][2]*a[2][1] - a[1][0]*a[0][1]*a[2][2]
  )

func transpose*(a: Basis): Basis =
  ## Transposes basis
  Basis(
    x: Vec3(x: a[0][0], y: a[1][0], z: a[2][0]),
    y: Vec3(x: a[0][1], y: a[1][1], z: a[2][1]),
    z: Vec3(x: a[0][2], y: a[1][2], z: a[2][2])
  )
