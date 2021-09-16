port module Ports exposing (..)
import Music exposing (RawMusic)


port minimize : () -> Cmd msg


port close : () -> Cmd msg


port loadMusic : (RawMusic -> msg) -> Sub msg