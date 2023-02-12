#[
  Provides low-level animatable objects
]#
import
  math


type
  Animatable*[T] = object
    value*: T
  Easing* = enum
    LINEAR
    EASE_IN_OUT_SINE
    EASE_IN_SINE
    EASE_OUT_SINE


func animatable*[T](val: T): Animatable[T] =
  ## Creates a new Animatable value
  Animatable[T](value: val)


func tween*[T](a, b: Animatable[T], t: 0f..1f, easing: Easing): Animatable[T] =
  ## Returns animatable value at `t` position between `a` and `b`.
  ## 
  ## Arguments:
  ## - `a` - start position;
  ## - `b` - end position;
  ## - `t` - number between 0 and 1, where 0 is start and 1 is end;
  ## - `easing` - easing mo de
  case easing:
  of LINEAR:
    Animatable[T](value: a.value + t * (b.value - a.value))
  of EASE_IN_OUT_SINE:
    Animatable[T](value: a.value + (b.value - a.value) * -(cos(PI * t) - 1f) / 2f)
  of EASE_IN_SINE:
    Animatable[T](value: a.value + (b.value - a.value) * 1f - cos((t * PI) / 2f))
  of EASE_OUT_SINE:
    Animatable[T](value: a.value + (b.value - a.value) * cos((t * PI) / 2f))


func tween*[T](a: Animatable[T], b: T, t: 0f..1f, easing: Easing): Animatable[T] =
  ## Returns animatable value at `t` position between `a` and `b`.
  tween(a, animatable(b), t, easing)
