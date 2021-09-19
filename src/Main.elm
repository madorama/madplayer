module Main exposing (..)

import Browser exposing (Document)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events exposing (..)
import Css
import Css.Global as G
import Css.Transitions as T
import Response exposing (..)

import Madlib.Layout exposing (..)
import Madlib.Mixin as Mixin
import Madlib.Css as Css

import Style
import Icon
import Ports
import Music exposing (Music, RawMusic)


type Msg
  = ClickMinimize
  | ClickClose
  | LoadMusic RawMusic


type alias Model =
  { musics : List Music
  }


init : () -> Response Model Msg
init flags =
  { musics = []
  }
    |> withNone


update : Msg -> Model -> Response Model Msg
update msg model =
  case msg of
    ClickMinimize ->
      model
        |> withCmd (Ports.minimize ())

    ClickClose ->
      model
        |> withCmd (Ports.close ())

    LoadMusic music ->
      { model
        | musics = List.append model.musics [(Music.gen music)]
      }
        |> withNone


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Ports.loadMusic LoadMusic
    ]


view : Model -> Document Msg
view model =
  { title = ""
  , body =
      [ Style.style
          |> toUnstyled
      , fill [] [ viewMain model ]
          |> toUnstyled
      ]
  }


viewMain : Model -> Html Msg
viewMain model =
  column
    [ Attr.css
        [ Css.width (Css.pct 100)
        , Css.height (Css.pct 100)
        , Css.backgroundColor (Css.hex "20242A")
        , Css.color (Css.hex "f0f0f0")
        ]
    ]
    [ viewTitleBar
    , viewPlayer model
    , viewMusics model
    ]


viewTitleBar : Html Msg
viewTitleBar =
  row
    [ Attr.class "titlebar"
    ]
    [ row
        [ Attr.css
            [ Css.overflow Css.hidden
            , Css.width (Css.pct 100)
            , Css.height (Css.pct 100)
            , centering
            ]
        ]
        [ div
            [ Attr.css
                [ Css.overflow Css.hidden
                , Css.paddingLeft (Css.px 8)
                , Css.textOverflow Css.ellipsis
                , Css.whiteSpace Css.noWrap
                ]
            ]
            [ text "Mad Player"
            ]
        ]
    , row
        [ Attr.class "button"
        , onClick ClickMinimize
        ]
        [ Icon.line "subtract" (Css.px 18)
        ]
    , row
        [ Attr.class "button"
        , Attr.class "close"
        , onClick ClickClose
        ]
        [ Icon.line "close" (Css.px 18)
        ]
    ]


viewPlayer : Model -> Html Msg
viewPlayer model =
  let
    buttonStyle =
      Attr.css
        [ Css.cursor Css.pointer
        , Css.width (Css.px 32)
        , Css.height (Css.px 32)
        , centering
        , T.transition
            [ T.backgroundColor 160
            ]
        , Css.hover
            [ Css.backgroundColor (Css.hex "50546A")
            ]
        ]
  in
  row
    []
    [ row
        [ buttonStyle
        ]
        [ Icon.fill "stop" (Css.px 24)
        ]
    , row
        [ buttonStyle
        ]
        [ Icon.fill "play" (Css.px 24)
        ]
    , row
        [ buttonStyle
        ]
        [ Icon.fill "skip-back" (Css.px 24)
        ]
    , row
        [ buttonStyle
        ]
        [ Icon.fill "skip-forward" (Css.px 24)
        ]
    ]


viewMusics : Model -> Html Msg
viewMusics model =
  column
    [ Attr.css
        [ Css.height (Css.pct 100)
        , Css.overflowY Css.auto
        -- ScrollBar
        , Css.pseudoElement "-webkit-scrollbar"
            [ Css.width (Css.px 10)
            , Css.backgroundColor (Css.colorLighten 0.05 (Css.hex "10141A"))
            ]
        , Css.pseudoElement "-webkit-scrollbar-track"
            [ Css.boxShadow5 Css.inset Css.zero Css.zero (Css.px 1) (Css.hex "10141A")
            ]
        , Css.pseudoElement "-webkit-scrollbar-thumb"
            [ Css.borderRadius (Css.px 8)
            , Css.backgroundColor (Css.colorAlpha 0.5 (Css.hex "70747A"))
            ]
        ]
    ]
    (List.map viewMusic model.musics)


viewMusic : Music -> Html Msg
viewMusic music =
  row
    [ Attr.class "music"
    , Attr.css
        [ Css.padding (Css.px 8)
        , Css.width (Css.pct 100)
        , Css.nthChild "even"
            [ Css.backgroundColor (Css.colorLighten 0.075 (Css.hex "20242A"))
            ]
        ]
    ]
    [ text (music.metadata.title |> Maybe.withDefault music.path)
    ]


main : Program () Model Msg
main =
  Browser.document
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
