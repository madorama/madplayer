module Madlib.Layout exposing
  ( centerX
  , centerY
  , centering
  , column
  , columnReverse
  , row
  , rowReverse
  , fill
  )

import Html.Styled as Html exposing (Html, Attribute)
import Html.Styled.Attributes as Attr
import Css
import Css.Global as G


centerX : Css.Style
centerX =
  Css.batch
    [ G.withClass "flex-column"
        [ Css.alignItems Css.center
        ]
    , G.withClass "flex-row"
        [ Css.justifyContent Css.center
        ]
    ]


centerY : Css.Style
centerY =
  Css.batch
    [ G.withClass "flex-column"
        [ Css.justifyContent Css.center
        ]
    , G.withClass "flex-row"
        [ Css.alignItems Css.center
        ]
    ]


centering : Css.Style
centering =
  Css.batch
    [ centerX
    , centerY
    ]



flexColumn : Bool -> List (Attribute msg) -> List (Html msg) -> Html msg
flexColumn isReverse attrs =
  let
    newAttrs =
      [ Attr.class "flex-column"
      , Attr.css
        [ Css.displayFlex
        , Css.flexDirection <|
            if isReverse
              then Css.columnReverse
              else Css.column
        ]
      ]
        ++ attrs
  in
  Html.div newAttrs


flexRow : Bool -> List (Attribute msg) -> List (Html msg) -> Html msg
flexRow isReverse attrs =
  let
    newAttrs =
      [ Attr.class "flex-row"
      , Attr.css
          [ Css.displayFlex
          , Css.flexDirection <|
              if isReverse
                then Css.rowReverse
                else Css.row
          ]
      ]
        ++ attrs
  in
  Html.div newAttrs


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
  flexColumn False


columnReverse : List (Attribute msg) -> List (Html msg) -> Html msg
columnReverse =
  flexColumn True


row : List (Attribute msg) -> List (Html msg) -> Html msg
row =
  flexRow False


rowReverse : List (Attribute msg) -> List (Html msg) -> Html msg
rowReverse =
  flexRow True


fill : List (Attribute msg) -> List (Html msg) -> Html msg
fill attrs =
  let
    newAttrs =
      Attr.css
        [ Css.width <| Css.pct 100
        , Css.height <| Css.vh 100
        ]
        :: attrs
  in
  column newAttrs
