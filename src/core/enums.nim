#[
  Provides enums
]#
type
  PauseBehavior* {.pure, size: sizeof(int8).} = enum
    Inherit,  ## behavior taken from parent node
    Stop,  ## behavior is stop
    Process  ## behavior is process
  Visibility* {.pure, size: sizeof(int8).} = enum
    Visible,  ## object is visible
    Invisible,  ## object is invisible, but just not renders
    Gone  ## objects is invisible and not calculates
  Align* {.pure, size: sizeof(int8).} = enum
    Start,  ## Equals Left/Top
    Center,
    End  ## Equals Right/Bottom