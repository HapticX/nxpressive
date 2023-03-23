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
    
    var i = 0
    scene@process():
      if i < 10:
        inc i
      else:
        i = 0
        app.title = app.title[1..^1] & app.title[0]
    
    var canvas = newHCanvas()
    scene.addChild(canvas)
    canvas.fill(newColor(1, 0.75, 1))
    canvas.drawRect(32, 32, 480, 480, BlackClr)
    canvas.drawRect(128, 256, 16, 96, RedClr)
    canvas.drawRect(111, 111, 160, 160, BlueClr)
    canvas.drawRect(130, 64, 128, 256, newColor(0, 1, 0, 0.5))

    app.run()
