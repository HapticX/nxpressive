import
  unittest,
  math,
  ../src/hapticx


suite "Core":
  test "Color":
    let clr = newColor(255, 100, 0)
    echo clr

    let rgbaHex = newColor(0xFFAA9944)
    echo rgbaHex

    let rgbHex = newColor(0xFFAA99)
    echo rgbHex

    let rgbStrHex = newColor("#FFAA99")
    echo rgbStrHex
    assert rgbHex == rgbStrHex

  test "Color blending":
    let rgbaHex = newColor(0xFFAA9944)
    let rgbHex = newColor(0xFFAA99)

    echo rgbaHex.blend(rgbHex, BlendMode.NORMAL)
    echo rgbaHex.blend(rgbHex, BlendMode.MULTIPLY)
    echo rgbaHex.blend(rgbHex, BlendMode.SCREEN)
    echo rgbaHex.blend(rgbHex, BlendMode.OVERLAY)
    echo rgbaHex.blend(rgbHex, BlendMode.ADDITION)
    echo rgbaHex.blend(rgbHex, BlendMode.DIVIDE)
    echo rgbaHex.blend(rgbHex, BlendMode.SUBSTRACT)
    echo rgbaHex.blend(rgbHex, BlendMode.DIFFERENCE)
    echo rgbaHex.blend(rgbHex, BlendMode.SOFT_LIGHT)
    echo rgbaHex.blend(rgbHex, BlendMode.DARKEN)
    echo rgbaHex.blend(rgbHex, BlendMode.LIGHTEN)
  
  test "hue":
    let rgb = newColor(50, 100, 200)
    echo rgb
    echo rgb.hue
    echo rgb.saturation
    echo rgb.brightness
    echo newColor(rgb.hex)
  
  test "Vec2":
    let vec2 = newVec2(0.5f, 1f)
    echo vec2

    assert radToDeg(Vec2Right.angle2(Vec2Up)) == 90f
    assert radToDeg(Vec2Up.angle2(Vec2Down)) == 180f
