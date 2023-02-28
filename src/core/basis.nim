#[
  Provides working with Basis
]#
import
  strformat,
  vec3,
  ./exceptions


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
    raise newException(OutOfIndexDefect, fmt"{index} is out of bounds")

func `[]=`*(a: var Basis, index: int, val: Vec3): float =
  if index == 0:
    a.x = val
  elif index == 1:
    a.y = val
  elif index == 2:
    a.z = val
  else:
    raise newException(OutOfIndexDefect, fmt"{index} is out of bounds")


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


template provideOperatorVar(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a: var Basis, b: Basis) =
    `op`(a.x, b.x)
    `op`(a.y, b.y)
    `op`(a.z, b.z)
  func `operatorFunc`*(a: var Basis, b: float) =
    `op`(a.x, b)
    `op`(a.y, b)
    `op`(a.z, b)
  func `operatorFunc`*(a: var Basis, b: Vec3) =
    `op`(a.x, b.x)
    `op`(a.y, b.y)
    `op`(a.z, b.z)

template provideBinOperator(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a, b: Basis): bool {.inline.} =
    `op`(a.x, b.x) and `op`(a.y, b.y) and `op`(a.z, b.z)


provideOperator(`+`, `+`)
provideOperator(`-`, `-`)
provideOperator(`/`, `/`)
provideOperator(`*`, `*`)

provideOperatorVar(`+=`, `+=`)
provideOperatorVar(`-=`, `-=`)
provideOperatorVar(`/=`, `/=`)
provideOperatorVar(`*=`, `*=`)

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

func minor*(a: Basis, x, y: int): float =
  ## Calculates minor of Basis.
  assert x >= 0 and x <= 2 and y >= 0 and y <= 2
  var row1, row2: Vec3

  case x:
  of 0:
    (row1, row2) = (a.y, a.z)
  of 1:
    (row1, row2) = (a.x, a.z)
  else:
    (row1, row2) = (a.x, a.y)
  
  case y:
  of 0:
    row1.y*row2.z - row1.z*row2.y
  of 1:
    row1.x*row2.z - row1.z*row2.x
  else:
    row1.x*row2.y - row1.y*row2.x

func normalized*(a: Basis): Basis {.inline.} =
  ## Normalizes every vector of basis
  Basis(
    x: a.x.normalized(),
    y: a.y.normalized(),
    z: a.z.normalized()
  )

func normalize*(a: var Basis) =
  ## Normalizes every vector of basis
  a.x.normalize()
  a.y.normalize()
  a.z.normalize()


func inverse*(a: Basis): Basis =
  ## Calculates inverse basis
  let det = a.determinant()
  assert det != 0
  let invDet = 1f/det
  Basis(
    x: Vec3(x: (a.y.y*a.z.z - a.z.y*a.y.z) * invDet, y: (a.z.x*a.y.z - a.y.x*a.z.z) * invDet, z: (a.y.x*a.z.y - a.z.x*a.y.y) * invDet),
    y: Vec3(x: (a.z.x*a.x.z - a.x.y*a.z.z) * invDet, y: (a.x.x*a.z.z - a.x.z*a.z.x) * invDet, z: (a.z.x*a.x.y - a.x.x*a.z.y) * invDet),
    z: Vec3(x: (a.x.y*a.y.z - a.y.y*a.x.z) * invDet, y: (a.y.x*a.x.z - a.x.x*a.y.z) * invDet, z: (a.x.x*a.y.y - a.y.x*a.x.y) * invDet),
  )

func isOrthogonal*(a: Basis): bool {.inline.} =
  ## Returns `true` if the basis vectors of `b` are mutually orthogonal.
  a.x.dot(a.y) == 0f and a.x.dot(a.z) == 0f and a.y.dot(a.z) == 0f

func isOrthonormal*(a: Basis): bool {.inline.} =
  ## Returns true when basis vectors of `a` are mutually ortogonal and each has unit length
  a.isOrthogonal() and a.x.isNorm and a.y.isNorm and a.z.isNorm
