import
  unittest,
  math,
  ../src/hapticx


suite "Core":
  test "Color":
    let clr = newColor(255, 100, 0)
    echo clr

    when not defined(js):
      let rgbaHex = newColor(0xFFAA9944)
      echo rgbaHex

    let rgbHex = newColor(0xFFAA99)
    echo rgbHex

    let rgbStrHex = newColor("#FFAA99")
    echo rgbStrHex
    assert rgbHex == rgbStrHex

  test "Color blending":
    let rgbaHex = newColor(0xFFBB99)
    let rgbHex = newColor(0x227722)

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
  
  test "interpolation":
    let
      vec1 = newVec2(0.25f, 0.75f)
      vec2 = newVec2(0.5f, 0f)
    
    echo vec1.interpolate(vec2, 0f)
    echo vec1.interpolate(vec2, 0.25f)
    echo vec1.interpolate(vec2, 0.5f)
    echo vec1.interpolate(vec2, 0.75f)
    echo vec1.interpolate(vec2, 1f)
  
  test "snap":
    let
      vec = newVec2(37f, 12f)
      snap = newVec2(5f, 5f)
    echo vec.snapped(snap)
  
  test "bounce":
    let
      vec1 = newVec2(1f, 2f)
      vec2 = newVec2(0.5f, 0.5f)
    
    echo vec1.bounce(vec2)
  
  test "Animatable":
    let
      x = animatable(0f)
      y = animatable(newColor(0xFF99FF))
      z = animatable(newVec2(1f, 5f))
    
    echo tween(x, 10f, 0.5f, LINEAR)
    echo tween(x, 10f, 0.5f, EASE_IN)
    echo tween(x, 10f, 0.5f, EASE_OUT)
    echo tween(x, 10f, 0.5f, EASE_IN_OUT)
    echo tween(x, 10f, 0.5f, QUAD_IN)
    echo tween(x, 10f, 0.5f, QUAD_OUT)
    echo tween(x, 10f, 0.5f, QUAD_IN_OUT)
    echo tween(x, 10f, 0.5f, CUBIC_IN)
    echo tween(x, 10f, 0.5f, CUBIC_OUT)
    echo tween(x, 10f, 0.5f, CUBIC_IN_OUT)
    echo tween(x, 10f, 0.5f, QUART_IN)
    echo tween(x, 10f, 0.5f, QUART_OUT)
    echo tween(x, 10f, 0.5f, QUART_IN_OUT)
    echo tween(x, 10f, 0.5f, QUINT_IN)
    echo tween(x, 10f, 0.5f, QUINT_OUT)
    echo tween(x, 10f, 0.5f, QUINT_IN_OUT)
    echo tween(x, 10f, 0.5f, EXPO_IN)
    echo tween(x, 10f, 0.5f, EXPO_OUT)
    echo tween(x, 10f, 0.5f, EXPO_IN_OUT)

    echo tween(y, newColor(0x999fff), 0f, CUBIC_IN)
    echo tween(y, newColor(0x999fff), 0.5f, CUBIC_IN)
    echo tween(y, newColor(0x999fff), 1f, CUBIC_IN)

    echo tween(z, newVec2(78f, -0.125f), 0.5f, CIRC_IN)
    echo tween(z, newVec2(78f, -0.125f), 0.5f, BACK_IN)
  
  test "Vec3":
    let
      v1 = newVec3()
      v2 = newVec3(10f)
      v3 = newVec3(1f, 2f, 4f)
    
    echo v1
    echo v2
    echo v3

    echo v2.dot(v3)
    echo v2.cross(v3)

    echo v2.rotatedX(90)
    echo v2.rotatedY(90)
    echo v2.rotatedZ(90)
