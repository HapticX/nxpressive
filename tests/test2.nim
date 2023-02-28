import
  unittest,
  ../src/hapticx


suite "Node":
  test "Init and free":
    let
      a = newHNode("Root")
      b = newHNode("Child1")
      c = newHNode("Child2")
    
    echo 1
    a.addChild(b, c)
    echo 1
    echo a
    echo 1
