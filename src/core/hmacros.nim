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
  if not evname.startsWith("on_"):
    evname = "on_" & evname
  elif evname.startsWith("on"):
    evname = "on_" & evname[2..^1]
  # ident
  let ev = ident(evname)

  case evname:
  of "on_ready", "on_destroy", "on_enter", "on_exit", "on_process":
    result = quote do:
      `node`.`ev` = proc(): void =
        `code`


macro defineNode*(nodes: untyped): untyped =
  ## Provides custom node definition via specified syntax:
  ## ```nim
  ## defineNode:
  ##   MyNode(RootNode):
  ##     - x float
  ##     - y float
  ##     - my_event proc(): void
  ## ```
  # nodes - nnkStmtList
  result = newNimNode(nnkTypeSection)
  for i in nodes.children:
    # i - nnkCall
    let
      new_type = newNimNode(nnkTypeDef)
      obj_ty = newNimNode(nnkObjectTy)
      rec_list = newNimNode(nnkRecList)
      inherit_from = newNimNode(nnkOfInherit)
    if len(i) > 2:
      for param in i[2]:
        # - NAME TYPE
        rec_list.add(newIdentDefs(
          postfix(param[1][0], "*"), param[1][1]
        ))
    new_type.add(postfix(i[0], "*"))
    new_type.add(newEmptyNode())
    new_type.add(obj_ty)
    
    obj_ty.add(newEmptyNode())
    obj_ty.add(inherit_from)
    obj_ty.add(rec_list)
    inherit_from.add(i[1])

    # Ref
    let 
      ref_type = newNimNode(nnkTypeDef)
      ref_obj_ty = newNimNode(nnkObjectTy)
      ref_ty = newNimNode(nnkRefTy)
    ref_type.add(postfix(ident($i[0] & "Ref"), "*"))
    ref_type.add(newEmptyNode())
    ref_type.add(ref_obj_ty)

    ref_ty.add(i[0])

    ref_obj_ty.add(newEmptyNode())
    ref_obj_ty.add(ref_ty)
    ref_obj_ty.add(newEmptyNode())

    result.add(new_type)
    result.add(ref_type)
