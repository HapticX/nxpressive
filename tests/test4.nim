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
    canvas.drawRect(128, 256, 16, 96, RedClr)
    canvas.drawRect(128, 0, 128, 96, BlueClr)
    canvas.drawRect(130, 64, 128, 256, newColor(0, 1, 0, 0.5))

    app.run()
