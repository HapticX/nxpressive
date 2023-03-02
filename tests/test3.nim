import
  unittest,
  ../src/hapticx


suite "App":
  test "Initialize":
    let app = newApp("HapticX")
