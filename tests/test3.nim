import
  unittest,
  ../src/hapticx


suite "App":
  test "Initialize":
    var
      app = newApp("HapticX")
      scene = newHScene()
    
    app.main = scene
    app.run()
