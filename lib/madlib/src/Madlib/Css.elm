module Madlib.Css exposing
  ( gap
  , placeholder
  , userSelect
  , userSelectNone
  , colorLighten
  , colorDarken
  , colorAlpha
  , animationIterationCountInfinite
  , TimingFunction(..)
  , animationTimingFunction
  )

import Css exposing (Style)
import Color
import Color.Manipulate as Color


gap : Css.LengthOrAuto compatible -> Style
gap length =
  Css.property "gap" length.value


placeholder : List Style -> Style
placeholder =
  Css.pseudoClass ":placeholder"


userSelect : String -> Style
userSelect =
  Css.property "user-select"


userSelectNone : Style
userSelectNone =
  userSelect "none"


toColor : Css.Color -> Color.Color
toColor color =
  let
    c =
      Color.rgb255 color.red color.green color.blue
        |> Color.toRgba
  in
  { c
    | alpha = color.alpha
  }
    |> Color.fromRgba


toCssColor : Color.Color -> Css.Color
toCssColor color =
  let
    c =
      Color.toRgba color

    r =
      floor <| 255 * c.red

    g =
      floor <| 255 * c.green

    b =
      floor <| 255 * c.blue
  in
  Css.rgba r g b c.alpha


colorLighten : Float -> Css.Color -> Css.Color
colorLighten pct =
  toColor
    >> Color.scaleHsl
        { saturationScale = 0
        , lightnessScale = pct
        , alphaScale = 0
        }
    >> toCssColor


colorDarken : Float -> Css.Color -> Css.Color
colorDarken pct =
  toColor
    >> Color.scaleHsl
        { saturationScale = 0
        , lightnessScale = -pct
        , alphaScale = 0
        }
    >> toCssColor


setAlpha : Float -> Color.Color -> Color.Color
setAlpha alpha color =
  color
    |> Color.toRgba
    |>
      (\c ->
          { c
            | alpha = alpha
          }
      )
    |> Color.fromRgba


colorAlpha : Float -> Css.Color -> Css.Color
colorAlpha a =
  toColor
    >> setAlpha a
    >> toCssColor


animationIterationCountInfinite : Style
animationIterationCountInfinite =
  Css.property "animation-iteration-count" "infinite"


type TimingFunction
  = Ease
  | Linear
  | EaseIn
  | EaseOut
  | EaseInOut
  | StepStart
  | StepEnd
  | CubicBezier Float Float Float Float


animationTimingFunction : TimingFunction -> Style
animationTimingFunction timing =
  let
    timingStr =
      case timing of
        Ease ->
          "ease"

        Linear ->
          "linear"

        EaseIn ->
          "ease-in"

        EaseOut ->
          "ease-out"

        EaseInOut ->
          "ease-in-out"

        StepStart ->
          "step-start"

        StepEnd ->
          "step-end"

        CubicBezier p1 p2 p3 p4 ->
          String.concat
            [ "cubic-bezier("
            , String.join ","
                [ String.fromFloat p1
                , String.fromFloat p2
                , String.fromFloat p3
                , String.fromFloat p4
                ]
            , ")"
            ]
  in
  Css.property "animation-timing-function" timingStr
