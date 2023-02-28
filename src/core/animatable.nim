#[
  Provides low-level animatable objects
]#
import
  strformat,
  math


type
  Animatable*[T] = object
    value*: T
  Easing* {.pure, size: sizeof(int8).} = enum
    LINEAR
    EASE_IN
    EASE_OUT
    EASE_IN_OUT
    QUAD_IN
    QUAD_OUT
    QUAD_IN_OUT
    CUBIC_IN
    CUBIC_OUT
    CUBIC_IN_OUT
    QUART_IN
    QUART_OUT
    QUART_IN_OUT
    QUINT_IN
    QUINT_OUT
    QUINT_IN_OUT
    EXPO_IN
    EXPO_OUT
    EXPO_IN_OUT
    CIRC_IN
    CIRC_OUT
    CIRC_IN_OUT
    BACK_IN
    BACK_OUT
    BACK_IN_OUT
    ELASTIC_IN
    ELASTIC_OUT
    ELASTIC_IN_OUT


func animatable*[T](val: T): Animatable[T] =
  ## Creates a new Animatable value
  Animatable[T](value: val)


func tween*[T](a, b: Animatable[T], t: float, easing: Easing): Animatable[T] =
  ## Returns animatable value at `t` position between `a` and `b`.
  ## 
  ## Arguments:
  ## - `a` - start position;
  ## - `b` - end position;
  ## - `t` - number between 0 and 1, where 0 is start and 1 is end;
  ## - `easing` - easing mode
  let val =
    case easing:
    of LINEAR:
      t
    of EASE_IN:
      1f - cos((t * PI) / 2f)
    of EASE_OUT:
      cos((t * PI) / 2f)
    of EASE_IN_OUT:
      -(cos(PI * t) - 1f) / 2f
    of QUAD_IN:
      t * t
    of QUAD_OUT:
      1f - (1f - t) * (1f - t)
    of QUAD_IN_OUT:
      if t < 0.5f:
        2 * t * t
      else:
        1f - pow(-2f * t + 2f, 2f) / 2f
    of CUBIC_IN:
      t * t * t
    of CUBIC_OUT:
      1 - pow(1f - t, 3f)
    of CUBIC_IN_OUT:
      if t < 0.5f:
        4f * t * t * t
      else:
        1f - pow(-2f * t + 2f, 3f) / 2f
    of QUART_IN:
      t * t * t * t * t
    of QUART_OUT:
      1 - pow(1f - t, 5f)
    of QUART_IN_OUT:
      if t < 0.5f:
        16f * t * t * t * t * t
      else:
        1f - pow(-2f * t + 2f, 5f) / 2f
    of QUINT_IN:
      t * t * t * t
    of QUINT_OUT:
      1 - pow(1f - t, 4f)
    of QUINT_IN_OUT:
      if t < 0.5f:
        8f * t * t * t * t
      else:
        1f - pow(-2f * t + 2f, 4f) / 2f
    of EXPO_IN:
      if t == 0f:
        0f
      else:
        pow(2f, 10f * t - 10f)
    of EXPO_OUT:
      if t == 1f:
        1f
      else:
        1f - pow(2f, -10f * t)
    of EXPO_IN_OUT:
      if t == 0f:
        0f
      elif t == 1f:
        1f
      elif t < 0.5f:
        pow(2f, -20f * t + 10f) / 2f
      else:
        (2f - pow(2f, -20f * t + 10f)) / 2f
    of CIRC_IN:
      1f - sqrt(1f - pow(t, 2f))
    of CIRC_OUT:
      sqrt(1f - pow(t - 1f, 2f))
    of CIRC_IN_OUT:
      if t < 0.5f:
        (1f - sqrt(1f - pow(2f * t, 2f))) / 2f
      else:
        (sqrt(1f - pow(-2f * t + 2f, 2f)) + 1f) / 2f
    of BACK_IN:
      const
        c1 = 1.70158f
        c2 = c1 + 1f
      c2 * t * t * t - c1 * t * t
    of BACK_OUT:
      const
        c1 = 1.70158f
        c2 = c1 + 1f
      1f + c2 * pow(t - 1f, 3f) - c1 * pow(t - 1f, 2f)
    of BACK_IN_OUT:
      const
        c1 = 1.70158f
        c2 = c1 * 1.525
      if t < 0.5:
        (pow(2f * t, 2f) * ((c2 + 1f) * 2f * t - c2)) / 2f
      else:
        (pow(2f * t - 2f, 2f) * ((c2 + 1f) * (t * 2f - 2f) + c2) + 2) / 2f
    of ELASTIC_IN:
      const c = (2f * PI) / 3f
      if t == 0f:
        0f
      elif t == 1f:
        1f
      else:
        -pow(2f, 10f * t - 10f) * sin((t * 10f - 10.75f) * c)
    of ELASTIC_OUT:
      const c = (2f * PI) / 3f
      if t == 0f:
        0f
      elif t == 1f:
        1f
      else:
        pow(2f, -10f * t) * sin((t  * 10f - 0.75f) * c) + 1f
    of ELASTIC_IN_OUT:
      const c = (2f * PI) / 4.5f
      if t == 0f:
        0f
      elif t == 1f:
        1f
      elif t < 0.5:
        -pow(2f, 20f * t - 10f) * sin((20f * t - 11.125f) * c) / 2f
      else:
        pow(2f, -20f * t + 10f) * sin((20f * t - 11.125f) * c) / 2f + 1f
  Animatable[T](value: a.value + ((b.value - a.value) * val))


func tween*[T](a: Animatable[T], b: T, t: 0f..1f, easing: Easing): Animatable[T] =
  ## Returns animatable value at `t` position between `a` and `b`.
  tween(a, animatable(b), t, easing)


func `$`*[T](a: Animatable[T]): string =
  ## Returns string representation
  fmt"animatable[{a.value}]"
