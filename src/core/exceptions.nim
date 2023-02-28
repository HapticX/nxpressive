#[
  Describes all engine exceptions
]#

when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
  type
    OutOfIndexDefect* = object of Exception  ## Raises when index out of bounds
else:
  type
    OutOfIndexDefect* = object of Defect  ## Raises when index out of bounds
