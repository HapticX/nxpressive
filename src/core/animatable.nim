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
    Linear
    EaseIn
    EaseOut
    EaseInOut
    QuadIn
    QuadOut
    QuadInOut
    CubicIn
    CubicOut
    CubicInOut
    QuartIn
    QuartOut
    QuartInOut
    QuintIn
    QuintOut
    QuintInOut
    ExpoIn
    ExpoOut
    ExpoInOut
    CircIn
    CircOut
    CircInOut
    BackIn
    BackOut
    BackInOut
    ElasticIn
    ElasticOut
    ElasticInOut


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
    of Easing.Linear:
      t
    of Easing.EaseIn:
      1f - cos((t * PI) / 2f)
    of Easing.EaseOut:
      cos((t * PI) / 2f)
    of Easing.EaseInOut:
      -(cos(PI * t) - 1f) / 2f
    of Easing.QuadIn:
      t * t
    of Easing.QuadOut:
      1f - (1f - t) * (1f - t)
    of Easing.QuadInOut:
      if t < 0.5f:
        2 * t * t
      else:
        1f - pow(-2f * t + 2f, 2f) / 2f
    of Easing.CubicIn:
      t * t * t
    of Easing.CubicOut:
      1 - pow(1f - t, 3f)
    of Easing.CubicInOut:
      if t < 0.5f:
        4f * t * t * t
      else:
        1f - pow(-2f * t + 2f, 3f) / 2f
    of Easing.QuartIn:
      t * t * t * t * t
    of Easing.QuartOut:
      1 - pow(1f - t, 5f)
    of Easing.QuartInOut:
      if t < 0.5f:
        16f * t * t * t * t * t
      else:
        1f - pow(-2f * t + 2f, 5f) / 2f
    of Easing.QuintIn:
      t * t * t * t
    of Easing.QuintOut:
      1 - pow(1f - t, 4f)
    of Easing.QuintInOut:
      if t < 0.5f:
        8f * t * t * t * t
      else:
        1f - pow(-2f * t + 2f, 4f) / 2f
    of Easing.ExpoIn:
      if t == 0f:
        0f
      else:
        pow(2f, 10f * t - 10f)
    of Easing.ExpoOut:
      if t == 1f:
        1f
      else:
        1f - pow(2f, -10f * t)
    of Easing.ExpoInOut:
      if t == 0f:
        0f
      elif t == 1f:
        1f
      elif t < 0.5f:
        pow(2f, -20f * t + 10f) / 2f
      else:
        (2f - pow(2f, -20f * t + 10f)) / 2f
    of Easing.CircIn:
      1f - sqrt(1f - pow(t, 2f))
    of Easing.CircOut:
      sqrt(1f - pow(t - 1f, 2f))
    of Easing.CircInOut:
      if t < 0.5f:
        (1f - sqrt(1f - pow(2f * t, 2f))) / 2f
      else:
        (sqrt(1f - pow(-2f * t + 2f, 2f)) + 1f) / 2f
    of Easing.BackIn:
      const
        c1 = 1.70158f
        c2 = c1 + 1f
      c2 * t * t * t - c1 * t * t
    of Easing.BackOut:
      const
        c1 = 1.70158f
        c2 = c1 + 1f
      1f + c2 * pow(t - 1f, 3f) - c1 * pow(t - 1f, 2f)
    of Easing.BackInOut:
      const
        c1 = 1.70158f
        c2 = c1 * 1.525
      if t < 0.5:
        (pow(2f * t, 2f) * ((c2 + 1f) * 2f * t - c2)) / 2f
      else:
        (pow(2f * t - 2f, 2f) * ((c2 + 1f) * (t * 2f - 2f) + c2) + 2) / 2f
    of Easing.ElasticIn:
      const c = (2f * PI) / 3f
      if t == 0f:
        0f
      elif t == 1f:
        1f
      else:
        -pow(2f, 10f * t - 10f) * sin((t * 10f - 10.75f) * c)
    of Easing.ElasticOut:
      const c = (2f * PI) / 3f
      if t == 0f:
        0f
      elif t == 1f:
        1f
      else:
        pow(2f, -10f * t) * sin((t  * 10f - 0.75f) * c) + 1f
    of Easing.ElasticInOut:
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


func tween*[T](a: Animatable[T], b: T, t: float, easing: Easing): Animatable[T] =
  ## Returns animatable value at `t` position between `a` and `b`.
  tween(a, animatable(b), t, easing)


func `$`*[T](a: Animatable[T]): string =
  ## Returns string representation
  fmt"animatable[{a.value}]"
