module Style exposing (..)


import Html.Styled exposing (Html)
import Css exposing (..)
import Css.Global as G
import Css.Transitions as T

import Madlib.Layout exposing (centering)
import Madlib.Css as Css


style : Html msg
style =
  G.global
    [ G.everything
        [ Css.userSelectNone
        ]
    , G.class "titlebar"
        [ titleBar
        ]
    ]


titleBar : Style
titleBar =
  let
    backColor =
      Css.hex "303438"
  in
  Css.batch
    [ Css.width (Css.pct 100)
    , Css.height (Css.px 32)
    , Css.color (Css.hex "f0f0f0")
    , Css.backgroundColor backColor
    , Css.property "-webkit-app-region" "drag"
    , G.children
        [ G.class "button"
            [ Css.width (Css.px 48)
            , Css.height (Css.pct 100)
            , Css.padding2 Css.zero (Css.px 12)
            , Css.property "-webkit-app-region" "no-drag"
            , Css.cursor Css.pointer
            , centering
            , T.transition
                [ T.backgroundColor3 60 0 T.linear
                ]
            , Css.hover
                [ Css.backgroundColor (Css.colorLighten 0.2 backColor)
                , G.withClass "close"
                    [ Css.backgroundColor (Css.hex "e22")
                    ]
                ]
            ]
        ]
    ]