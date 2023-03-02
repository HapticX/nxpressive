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
  # Extract event name
  var event_name: string
  if event.kind == nnkCall:
    event_name = $event[0]
  elif event.kind == nnkIdent:
    event_name = $event
  # Ready -> on_ready
  var evname = event_name.toLower()
  if not evname.startsWith("on"):
    evname = "on_" & evname
  # ident
  let ev = ident(evname)

  case evname:
  of "on_ready", "on_destroy":
    result = quote do:
      `node`.`ev` = proc(): void =
        `code`
