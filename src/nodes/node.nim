#[
  Provides HNode behavior
]#
import strformat


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


method addChild*(self, node: HNodeRef) {.base, noSideEffect.} =
  ## Adds child `node` into `self`
  self.children.add(node)
  node.parent = self


method addChild*(self: HNodeRef, args: varargs[HNodeRef]) {.base, noSideEffect.} =
  ## Add new nodes into `self`
  for node in args:
    self.addChild(node)


func childIndex*(self, node: HNodeRef): int =
  ## Search node in `self` children and returns its index.
  ## Returns -1, when not found
  for (index, child) in self.children.pairs:
    if child == node:
      return index
  -1


func free*(self: HNodeRef) {.noreturn.} =
  for node in self.children:
    node.free()
  if not isNil(self.parent):
    self.parent.children.del(self.parent.childIndex(self))


func `$`*(self: HNodeRef): string =
  fmt"HNode({self.tag})"
