module Icon exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Css


line : String -> Css.FontSize compatible -> Html msg
line name fontSize =
  span
    [ Attr.css
        [ Css.fontSize fontSize
        ]
    , Attr.class (String.join "-" ["ri", name, "line"])
    ]
    []


fill : String -> Css.FontSize compatible -> Html msg
fill name fontSize =
  span
    [ Attr.css
        [ Css.fontSize fontSize
        ]
    , Attr.class (String.join "-" ["ri", name, "fill"])
    ]
    []