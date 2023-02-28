#[
  Provides all macros
]#
import
  macros,
  strutils,
  ../nodes/node


macro `@`*(node: HNodeRef, event, code: untyped): untyped =
  ## Provides events handling syntax like this:
  ## ```nim
  ## node@destroy():
  ##   # handle node event
  ##   discard
  ## ```
  var event_name: string
  if event.kind == nnkCall:
    event_name = $event[0]
  elif event.kind == nnkIdent:
    event_name = $event
  
  event_name = event_name.toLower().replace("_", "")

  case event_name:
  of "onready", "ready":
    result = quote do:
      `node`.on_ready = proc(): void =
        `code`
  of "ondestroy", "destroy":
    result = quote do:
      `node`.on_destroy = proc(): void =
        `code`
