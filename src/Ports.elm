port module Ports exposing (..)
import Music exposing (RawMusic)


port minimize : () -> Cmd msg


port close : () -> Cmd msg


port loadMusic : (RawMusic -> msg) -> Sub msg


port playMusic : String -> Cmd msg


port resumeMusic : () -> Cmd msg


port pauseMusic : () -> Cmd msg


port stopMusic : () -> Cmd msg