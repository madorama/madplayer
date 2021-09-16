module Main exposing (..)

import Browser exposing (Document)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events exposing (..)
import Css
import Css.Global as G
import Response exposing (..)

import Madlib.Layout exposing (..)
import Madlib.Mixin as Mixin

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
    []
    [ viewTitleBar
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


viewMusics : Model -> Html Msg
viewMusics model =
  column
    []
    (List.map viewMusic model.musics)


viewMusic : Music -> Html Msg
viewMusic music =
  row
    []
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
