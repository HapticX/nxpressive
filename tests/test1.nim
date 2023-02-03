import unittest
import ../src/hapticx


suite "Core":
  test "Color":
    let clr = newColor(255, 100, 0)
    echo clr

    let rgbaHex = newColor(0xFFAA9944)
    echo rgbaHex

    let rgbHex = newColor(0xFFAA99)
    echo rgbHex
