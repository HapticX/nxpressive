#[
  Provides HNode behavior
]#
import
  strformat,
  strutils,
  ../core/exceptions,
  ../private/templates


type
  HNodeEvent* = proc(): void
  HNode* = object of RootObj
    is_ready*: bool
    tag*: string
    parent*: HNodeRef
    children*: seq[HNodeRef]
    # events
    on_ready*: HNodeEvent
    on_destroy*: HNodeEvent
  HNodeRef* = ref HNode


let
  default_event_handler* = proc(): void = discard


proc newHNode*(tag: string = "HNode"): HNodeRef =
  ## Creates a new HNode with tag
  defaultNode(HNodeRef)


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


method insertChild*(self, other: HNodeRef, idx: int) {.base, noSideEffect.} =
  ## Inserts new child at `idx` position
  if self == other:
    raise newException(SelfAdditionDefect, "Can not insert self to self node")

  if self.parent == other:
    other.parent.children.delete(other.parent.childIndex(other))
    other.parent.children.add(self)
    self.parent = other.parent
    other.parent = self
  elif not isNil(other.parent):
    other.parent.children.delete(other.parent.childIndex(other))
    other.parent = self
  self.children.insert(other, idx)


# ---=== Abstract method ===--- #
method draw*(self: HNodeRef) {.base, error.} =
  ## Abstract method
  discard


# ---=== Base functions ===--- #
proc destroy*(self: HNodeRef) =
  ## Destroys node.
  ## This calls `destroyed` callback.
  self.on_destroy()
  for node in self.children:
    node.destroy()
  if not isNil(self.parent):
    self.parent.children.del(self.parent.childIndex(self))
    self.parent = nil


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


func getByTag*(self: HNodeRef, tag: string): HNodeRef =
  ## Returns first node by tag
  for node in self.iter():
    if node.tag == tag:
      return node
  return nil


func getRootNode*(self: HNodeRef): HNodeRef =
  ## Returns root node
  result = self
  while not isNil(result.parent):
    result = result.parent


func hasChild*(self, other: HNodeRef): bool =
  ## Returns true when `self` contains `other`
  other.parent == self and other in self.children


func hasParent*(self: HNodeRef): bool =
  ## Returns true when has parent
  not isNil(self.parent)


func delChild*(self, child: HNodeRef) =
  ## Deletes child and moves last child to deleted child postition.
  ## It's O(1) operation
  let idx = self.childIndex(child)
  if idx < 0:
    raise newException(OutOfIndexDefect, "Index out of bounds")
  self.children.del(idx)


func delChild*(self: HNodeRef, idx: int) =
  ## Deletes child and moves last child to deleted child postition.
  ## It's O(1) operation
  if idx < 0:
    raise newException(OutOfIndexDefect, "Index out of bounds")
  self.children.del(idx)


func deleteChild*(self, child: HNodeRef) =
  ## Deletes child and moves all next children by one pos.
  ## It's O(n) operation
  let idx = self.childIndex(child)
  if idx < 0:
    raise newException(OutOfIndexDefect, "Index out of bounds")
  self.children.delete(idx)


func deleteChild*(self: HNodeRef, idx: int) =
  ## Deletes child and moves all next children by one pos.
  ## It's O(n) operation
  if idx < 0:
    raise newException(OutOfIndexDefect, "Index out of bounds")
  self.children.delete(idx)


# ---=== Operators ===--- #
func `[]`*(self: HNodeRef, idx: int): HNodeRef =
  ## Returns child at `idx` position.
  self.children[idx]

func `$`*(self: HNodeRef): string =
  ## Returns string representation of HNode
  fmt"HNode({self.tag})"

func `~`*(self: HNodeRef): string =
  ## Returns tree representation of node.
  result = $self & "\n"
  for (lvl, node) in self.iterLvl():
    let padding = "  ".repeat(lvl)
    result &= fmt"{padding}{node}" & "\n"
