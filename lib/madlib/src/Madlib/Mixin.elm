module Madlib.Mixin exposing
  ( Mixin
  , lift
  , toAttributes
  , fromAttributes
  , map
  , batch
  , none
  , when
  , unless
  , fromAttribute
  , attribute
  , class
  , classList
  , id
  , css
  , property
  )

import Html.Styled as Html exposing (Html, Attribute)
import Html.Styled.Attributes as Attr
import Css
import Json.Encode exposing (Value)


type Mixin msg
  = Mixin (List (Attribute msg))


lift
  : (List (Attribute msg) -> List (Html msg) -> Html msg)
  -> List (Mixin msg)
  -> List (Html msg)
  -> Html msg
lift html mixins =
  mixins
    |> List.concatMap toAttributes
    |> html


toAttributes : Mixin msg -> List (Attribute msg)
toAttributes (Mixin attrs) =
  attrs


fromAttributes : List (Attribute msg) -> Mixin msg
fromAttributes attrs =
  Mixin attrs


map : (a -> b) -> Mixin a -> Mixin b
map f (Mixin attrs) =
  List.map (Attr.map f) attrs
    |> Mixin


batch : List (Mixin msg) -> Mixin msg
batch ms =
  List.concatMap toAttributes ms
    |> fromAttributes


none : Mixin msg
none =
  Mixin []


when : Bool -> Mixin msg -> Mixin msg
when c m =
  if c then
    m

  else
    none


unless : Bool -> Mixin msg -> Mixin msg
unless =
  not >> when


fromAttribute : Attribute msg -> Mixin msg
fromAttribute attr =
  Mixin [attr]


attribute : String -> String -> Mixin msg
attribute name val =
  Attr.attribute name val
    |> fromAttribute


class : String -> Mixin msg
class =
  Attr.class >> fromAttribute


classList : List (String, Bool) -> Mixin msg
classList =
  Attr.classList >> fromAttribute


id : String -> Mixin msg
id =
  Attr.id >> fromAttribute


css : List Css.Style -> Mixin msg
css =
  Attr.css >> fromAttribute


property : String -> Value -> Mixin msg
property name val =
  Attr.property name val
    |> fromAttribute