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

  test "Color blending":
    let rgbaHex = newColor(0xFFAA9944)
    let rgbHex = newColor(0xFFAA99)

    echo rgbaHex.blend(rgbHex, BlendMode.NORMAL)
    echo rgbaHex.blend(rgbHex, BlendMode.MULTIPLY)
    echo rgbaHex.blend(rgbHex, BlendMode.SCREEN)
    echo rgbaHex.blend(rgbHex, BlendMode.OVERLAY)
