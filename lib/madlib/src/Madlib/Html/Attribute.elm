module Madlib.Html.Attribute exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes as Attr


when : Bool -> Attribute msg -> Attribute msg
when c attr =
  if c then
    attr

  else
    Attr.class ""


unless : Bool -> Attribute msg -> Attribute msg
unless =
  not >> when


maybe : Maybe a -> (a -> Attribute msg) -> Attribute msg
maybe m f =
  m
    |> Maybe.map f
    |> Maybe.withDefault (Attr.class "")