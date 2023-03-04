#[
  Provides helpful math functions
]#
{.push inline.}
func interpolate*(a, b, t: float): float =
  ## Returns linear interpolation
  ## `a` - start
  ## `b` - end
  ## `t` interpolate value between 0 and 1
  a + t*(b-a)

func cubic_interpolate*(a, b, ca, cb, t: float): float =
  ## Returns cubic interpolation
  ## `a` - start
  ## `ca` - helps for `a`
  ## `b` - end
  ## `cb` - helps for `b`
  ## `t` interpolate value between 0 and 1
  a + t*(b - a + t*t*(1-t)*(ca - a + t*t*t*(b - a + cb - ca)))
{.pop.}
