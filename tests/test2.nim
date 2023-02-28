import
  unittest,
  ../src/hapticx


suite "Node":
  test "Init and free":
    let
      a = newHNode("Root")
      b = newHNode("Child1")
      c = newHNode("Child2")
    
    a.addChild(b, c)
    echo a
    echo a.repr

    b.destroy()
    echo a.repr

    a.addChild(b)
    echo a.repr

    c.addChild(b)
    echo a.repr

    b.addChild(c)
    echo a.repr
