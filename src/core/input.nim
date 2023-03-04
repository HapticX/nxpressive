#[
  Provides input events
]#
import
  unicode,
  ../thirdparty/sdl2


type
  InputEventType* {.pure, size: sizeof(int8).} = enum
    Mouse,
    Touch,
    Motion,
    Wheel,
    Keyboard,
    Text,
    Unknown

  InputEvent* = object
    kind*: InputEventType
    x*, y*, xrel*, yrel*: float
    key_int*: cint
    button_index*: cint
    key*: string
    pressed*: bool

  InputAction* = object
    kind*: InputEventType
    key_int*: cint
    button_index*: cint
    name*, key*: string


var
  actions: seq[InputAction] = @[]
  pressed_keys*: seq[cint] = @[]
  press_state*: cint = 0
  last_event* = InputEvent()
  mouse_pressed = false


{.push inline.}
func isInputEventUnknown*(a: InputEvent): bool = a.kind == InputEventType.Unknown
func isInputEventKeyboard*(a: InputEvent): bool = a.kind == InputEventType.Keyboard
func isInputEventMouse*(a: InputEvent): bool = a.kind == InputEventType.Mouse
func isInputEventTouch*(a: InputEvent): bool = a.kind == InputEventType.Touch
func isInputEventMotion*(a: InputEvent): bool = a.kind == InputEventType.Motion
func isInputEventText*(a: InputEvent): bool = a.kind == InputEventType.Text
func isInputEventWheel*(a: InputEvent): bool = a.kind == InputEventType.Wheel

proc regButtonAction*(name: string, button: cint | uint8) =
  actions.add(InputAction(kind: InputEventType.Mouse, name: name, button_index: button.cint))
proc regKeyAction*(name, key: string) =
  actions.add(InputAction(kind: InputEventType.Keyboard, name: name, key: key))
proc regKeyAction*(name: string, key: cint) =
  actions.add(InputAction(kind: InputEventType.Keyboard, name: name, key_int: key))
proc regTouchAction*(name: string) =
  actions.add(InputAction(kind: InputEventType.Touch, name: name))
{.pop.}


proc isActionJustPressed*(name: string): bool =
  ## Returns true when action with `name` is pressed only one times
  for action in actions:
    if action.name == name and press_state == 0:
      if action.kind == InputEventType.Mouse and
         action.button_index == last_event.button_index and mouse_pressed and press_state == 0:
        return true
      elif action.kind == InputEventType.Touch and action.kind == last_event.kind:
        return true
      elif action.kind == InputEventType.Keyboard and last_event.kind == action.kind:
        if action.key_int == last_event.key_int or action.key == last_event.key or
           action.key == $Rune(last_event.key_int):
          return true
  return false


proc isActionPressed*(name: string): bool =
  ## Returns true when action with `name` is pressed more times
  for action in actions:
    if action.name == name:
      if action.kind == InputEventType.Mouse and
         action.button_index == last_event.button_index and mouse_pressed:
        return true
      elif action.kind == InputEventType.Touch and press_state > 0:
        return true
      elif action.kind == InputEventType.Keyboard and action.key_int in pressed_keys:
        return true
  return false


proc isActionReleased*(name: string): bool =
  ## Returns true when action was released
  for action in actions:
    if action.name == name:
      if action.kind == InputEventType.Mouse and last_event.kind in [InputEventType.Mouse, InputEventType.Motion] and
         action.button_index == last_event.button_index and not mouse_pressed and press_state == 0:
          return true
      elif action.kind == InputEventType.Keyboard and last_event.kind == action.kind and press_state == 0:
        if action.key == $Rune(last_event.key_int) or action.key == last_event.key or action.key_int == last_event.key_int:
          return true
  return false
