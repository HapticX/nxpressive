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
    echo ~a

    b.destroy()
    echo ~a

    a.addChild(b)
    echo ~a

    c.addChild(b)
    echo ~a

    b.addChild(c)
    echo ~a

  test "event syntax":
    let a = newHNode()
    
    a@ready():
      echo 1
  
  test "custom nodes":
    defineNode:
      MyNode(HNode):
        - title string
    
    let node = MyNodeRef(title: "123")
    echo node.title
