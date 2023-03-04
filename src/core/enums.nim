#[
  Provides enums
]#
type
  PauseBehavior* {.pure, size: sizeof(int8).} = enum
    Inherit,  ## behavior taken from parent node
    Stop,  ## behavior is stop
    Process  ## behavior is process