#[
  Provides some util funcitons
]#


func interpolate*(a, b, t: float): float {.inline.} =
  ## Returns linear interpolation
  a + t*(b-a)

func cubic_interpolate*(a, b, ca, cb, t: float): float {.inline.} =
  ## Returns cubic interpolation
  a + t*(b - a + t*t*(1-t)*(ca - a + t*t*t*(b - a + cb - ca)))
