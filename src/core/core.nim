#[
  Provides some util funcitons
]#


func interpolate*(a, b, t: float): float {.inline.} =
  ## Returns linear interpolation
  a + t*(b-a)

func cubic_interpolate*(a, b, ca, cb, t: float): float {.inline.} =
  ## Returns cubic interpolation
  a + t*(b - a + t*t*(1-t)*(ca - a + t*t*t*(b - a + cb - ca)))


# Adaptive some functions for JS
when defined(js):
  # os.sleep(milliseconds)
  {.emit: "function jsSleep(ms){const d=Date.now();let c = null;do{c=Date.now();}while(c-d<ms);}".}
  proc jsSleep*(ms: int) {.importc, nodecl.}
