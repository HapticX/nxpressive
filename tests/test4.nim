import
  unittest,
  ../src/hapticx


suite "Drawing":
  test "Draw":
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
    
    var canvas = newHCanvas()
    scene.addChild(canvas)

    app.run()
