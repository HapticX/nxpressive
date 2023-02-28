#[
  Provides HNode behavior
]#
import
  strformat,
  strutils,
  ../core/exceptions


type
  HNodeEvent* = proc(): void
  HNode* = object of RootObj
    parent*: HNodeRef
    children*: seq[HNodeRef]
    tag*: string
    # events
    created*: HNodeEvent
    destroyed*: HNodeEvent
  HNodeRef* = ref HNode


let
  default_event_handler* = proc(): void = discard


proc newHNode*(tag: string = "HNode"): HNodeRef =
  ## Creates a new HNode with tag
  HNodeRef(
    children: @[],
    tag: tag,
    created: default_event_handler,
    destroyed: default_event_handler
  )


func childIndex*(self, node: HNodeRef): int =
  ## Search node in `self` children and returns its index.
  ## Returns -1, when not found
  for (index, child) in self.children.pairs:
    if child == node:
      return index
  -1


method addChild*(self, node: HNodeRef) {.base, noSideEffect.} =
  ## Adds child `node` into `self`
  ## 
  ## Swaps/moves nodes in tree, if parent of `self` is `node`.
  if node == self:
    raise newException(SelfAdditionDefect, "Can not add node to self.")

  # Self parent is node
  if self.parent == node:
    node.parent.children.add(self)
    self.children.add(node)
    node.parent.children.delete(node.parent.childIndex(node))
    node.children.delete(node.childIndex(self))
    self.parent = node.parent
    node.parent = self
  # Node has not parent
  elif isNil(node.parent):
    self.children.add(node)
    node.parent = self
  # Node already has other parent
  elif node.parent != self:
    node.parent.children.delete(node.parent.childIndex(node))
    self.children.add(node)
    node.parent = self
  # Self already has node child
  else:
    raise newException(AlreadyHasNodeDefect, fmt"{self.tag} already has {node.tag} in children.")


method addChild*(self: HNodeRef, args: varargs[HNodeRef]) {.base, noSideEffect.} =
  ## Add new nodes into `self`
  for node in args:
    self.addChild(node)


func iter*(self: HNodeRef): seq[HNodeRef] =
  ## Iterate all children of children
  result = @[]
  for i in self.children:
    result.add(i)
    for j in i.iter():
      result.add(j)


func iterLvl*(self: HNodeRef, lvl: int = 1): seq[tuple[lvl: int, node: HNodeRef]] =
  ## Iterate all children of children with their levels
  result = @[]
  for i in self.children:
    result.add((lvl, i))
    for (jl, jn) in i.iterLvl(lvl+1):
      result.add((jl, jn))


proc destroy*(self: HNodeRef) =
  self.destroyed()
  for node in self.children:
    node.destroy()
  if not isNil(self.parent):
    self.parent.children.del(self.parent.childIndex(self))
    self.parent = nil


func `$`*(self: HNodeRef): string =
  fmt"HNode({self.tag})"


func repr*(self: HNodeRef): string =
  result = fmt"HNode({self.tag})" & "\n"
  for (lvl, node) in self.iterLvl():
    let padding = "  ".repeat(lvl)
    result &= fmt"{padding}{node}" & "\n"
