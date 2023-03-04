import
  unittest,
  ../src/hapticx


suite "App":
  test "Initialize":
    var
      app = newApp("HapticX")
      scene = newHScene()
    
    # Sets main scene
    app.main = scene
    # Changes app icon
    app.icon = "./assets/hapticX.png"

    scene@ready():
      echo "ready"
    scene@enter():
      echo "enter"
    scene@exit():
      echo "exit"

    app.run()
