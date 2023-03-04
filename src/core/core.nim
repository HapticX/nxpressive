#[
  Provides cross-backend support
]#
# Adaptive some functions for JS
when defined(js):
  # os.sleep(milliseconds)
  {.emit: "function jsSleep(ms){const d=Date.now();let c=null;do{c=Date.now()}while(c-d<ms)}".}
  proc jsSleep*(ms: int) {.importc, nodecl.}
