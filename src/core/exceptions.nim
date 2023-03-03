#[
  Describes all engine exceptions
]#

type
  OutOfIndexDefect* = object of CatchableError  ## Raises when index out of bounds
  AlreadyHasNodeDefect* = object of CatchableError  ## Raises when node already has other node
  SelfAdditionDefect* = object of CatchableError  ## Raises when trying add node in it
  MainSceneNotDefinedDefect* = object of CatchableError  ## Raises when trying launch app without main scene
