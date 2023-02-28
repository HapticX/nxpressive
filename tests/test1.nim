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

    echo rgbaHex.blend(rgbHex, BlendMode.Normal)
    echo rgbaHex.blend(rgbHex, BlendMode.Multiply)
    echo rgbaHex.blend(rgbHex, BlendMode.Screen)
    echo rgbaHex.blend(rgbHex, BlendMode.Overlay)
    echo rgbaHex.blend(rgbHex, BlendMode.Addition)
    echo rgbaHex.blend(rgbHex, BlendMode.Divide)
    echo rgbaHex.blend(rgbHex, BlendMode.Substract)
    echo rgbaHex.blend(rgbHex, BlendMode.Diffirence)
    echo rgbaHex.blend(rgbHex, BlendMode.SoftLight)
    echo rgbaHex.blend(rgbHex, BlendMode.Darken)
    echo rgbaHex.blend(rgbHex, BlendMode.Lighten)
  
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
    
    echo tween(x, 10f, 0.5f, Easing.Linear)
    echo tween(x, 10f, 0.5f, Easing.CubicIn)
    echo tween(x, 10f, 0.5f, Easing.CubicInOut)
    echo tween(x, 10f, 0.5f, Easing.CubicOut)
    echo tween(x, 10f, 0.5f, Easing.ElasticIn)
    echo tween(x, 10f, 0.5f, Easing.ElasticOut)
    echo tween(x, 10f, 0.5f, Easing.ElasticInOut)
    echo tween(x, 10f, 0.5f, Easing.ExpoIn)
    echo tween(x, 10f, 0.5f, Easing.ExpoInOut)
    echo tween(x, 10f, 0.5f, Easing.BackOut)
    echo tween(x, 10f, 0.5f, Easing.EaseIn)

    echo tween(y, newColor(0x999fff), 0f, Easing.CubicIn)
    echo tween(y, newColor(0x999fff), 0.5f, Easing.CubicIn)
    echo tween(y, newColor(0x999fff), 1f, Easing.CubicIn)

    echo tween(z, newVec2(78f, -0.125f), 0.5f, Easing.CubicIn)
    echo tween(z, newVec2(78f, -0.125f), 0.5f, Easing.BackIn)
  
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
  
  test "Basis":
    let
      b1 = newBasis()
      b2 = newBasis(5f)
      b3 = newBasis(5f, 4f, 2f)
      b4 = newBasis(5f, 4f, 2f, 2f, 4f, 5f, 1f, 2f, 3f)
    echo b1
    echo b1.pretty()

    echo b2.pretty()
    echo (b2 * BasisDiagonal).pretty()

    echo BasisDiagonal.determinant

    echo b3.pretty()
    echo b3.transpose().pretty()
    echo b3.transpose().transpose() == b3

    echo b4.pretty()
    echo b4.minor(1, 1)
