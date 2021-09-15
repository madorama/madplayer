module Madlib.Html exposing (..)

import Html.Styled exposing (Html, text)


when : Bool -> Html msg -> Html msg
when c html =
  if c then
    html

  else
    text ""


unless : Bool -> Html msg -> Html msg
unless =
  not >> when


maybe : Maybe a -> (a -> Html msg) -> Html msg
maybe m f =
  m
    |> Maybe.map f
    |> Maybe.withDefault (text "")
