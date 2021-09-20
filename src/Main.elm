module Main exposing (..)

import Browser exposing (Document)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events exposing (..)
import Css
import Css.Global as G
import Css.Transitions as T
import Response exposing (..)
import List.Extra as List

import Madlib.Layout exposing (..)
import Madlib.Mixin as Mixin
import Madlib.Html.Attribute as Attr
import Madlib.Css as Css

import Style
import Icon
import Ports
import Music exposing (Music, RawMusic)


type Msg
  = ClickMinimize
  | ClickClose
  | LoadMusic RawMusic
  | PlayMusic Int
  | ClickPlay
  | ClickPause


type alias Model =
  { musics : List Music
  , isPlay : Bool
  , lastPlayIndex : Maybe Int
  }


init : () -> Response Model Msg
init flags =
  { musics = []
  , isPlay = False
  , lastPlayIndex = Nothing
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

    PlayMusic index ->
      let
        music =
          model.musics
            |> List.getAt index
      in
      { model
        | isPlay = True
        , lastPlayIndex = Just index
      }
        |> withCmd
          ( case music of
              Just m ->
                Ports.playMusic m.path

              Nothing ->
                Cmd.none
          )

    ClickPlay ->
      case model.lastPlayIndex of
        Just _ ->
          { model
            | isPlay = True
          }
            |> withCmd (Ports.resumeMusic ())

        Nothing ->
          model
            |> withNone

    ClickPause ->
      if model.isPlay then
        { model
          | isPlay = False
        }
          |> withCmd (Ports.pauseMusic ())

      else
        model
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
        , Css.backgroundColor (Css.hex "202428")
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

    playButton =
      row
        [ buttonStyle
        , onClick ClickPlay
        ]
        [ Icon.fill "play" (Css.px 24)
        ]

    pauseButton =
      row
        [ buttonStyle
        , onClick ClickPause
        ]
        [ Icon.fill "pause" (Css.px 24)
        ]
  in
  row
    [ Attr.css
        [ Css.width (Css.pct 100)
        , Css.backgroundColor (Css.hex "24282C")
        ]
    ]
    [ row
        [ buttonStyle
        ]
        [ Icon.fill "stop" (Css.px 24)
        ]
    , if model.isPlay then
        pauseButton

      else
        playButton
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
            , Css.backgroundColor (Css.colorLighten 0.05 (Css.hex "101418"))
            ]
        , Css.pseudoElement "-webkit-scrollbar-track"
            [ Css.boxShadow5 Css.inset Css.zero Css.zero (Css.px 1) (Css.hex "101418")
            ]
        , Css.pseudoElement "-webkit-scrollbar-thumb"
            [ Css.borderRadius (Css.px 8)
            , Css.backgroundColor (Css.colorAlpha 0.5 (Css.hex "606468"))
            ]
        ]
    ]
    (List.indexedMap (viewMusic model) model.musics)


viewMusic : Model -> Int -> Music -> Html Msg
viewMusic model index music =
  row
    [ Attr.class "music"
    , onClick (PlayMusic index)
    , Attr.maybe model.lastPlayIndex
        (\i ->
            Attr.when (i == index) (Attr.class "selected")
        )
    , Attr.css
        [ Css.padding (Css.px 8)
        , Css.width (Css.pct 100)
        , Css.nthChild "even"
            [ Css.backgroundColor (Css.colorLighten 0.025 (Css.hex "202428"))
            ]
        , G.withClass "selected"
            [ Css.backgroundColor (Css.hex "404448")
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
