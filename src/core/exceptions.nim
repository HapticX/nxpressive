#[
  Describes all engine exceptions
]#

when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
  type
    OutOfIndexDefect* = object of Exception
else:
  type
    OutOfIndexDefect* = object of Defect
