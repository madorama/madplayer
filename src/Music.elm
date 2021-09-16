module Music exposing
  ( RawMusic
  , Music
  , gen
  )


type alias RawMusic =
  { path : String
  , duration : Float
  , rawMetadata : RawMetadata
  }


type alias Music =
  { path : String
  , duration : Float
  , metadata : Metadata
  }


type alias Metadata =
  { title : Maybe String
  , artist : Maybe String
  , genres : List String
  , comment : Maybe String
  , bpm : Maybe Float
  }


type alias RawMetadata =
  { tagType : String
  , metadata : Metadata
  , rawData : List RawData
  }


type alias RawData =
  { id : String
  , value : String
  }


gen : RawMusic -> Music
gen data =
  { path = data.path
  , duration = data.duration
  , metadata = getMetadata data.rawMetadata
  }


getMetadata : RawMetadata -> Metadata
getMetadata raw =
  case raw.tagType of
    "exif" ->
      getExifMetadata raw.rawData

    "vorbis" ->
      getVorbisMetadata raw.metadata.bpm raw.rawData

    _ ->
      raw.metadata


getRawData : String -> List RawData -> List String
getRawData name rawData =
  rawData
    |> List.filter ((==) name << .id)
    |> List.map .value


getExifMetadata : List RawData -> Metadata
getExifMetadata rawData =
  let
    title =
      getRawData "INAM" rawData
        |> List.head

    artist =
      getRawData "IART" rawData
        |> List.head

    genres =
      getRawData "IGNR" rawData

    comment =
      getRawData "ICMT" rawData
        |> List.head
  in
  { title = title
  , artist = artist
  , genres = genres
  , comment = comment
  , bpm = Nothing
  }


getVorbisMetadata : Maybe Float -> List RawData -> Metadata
getVorbisMetadata bpm rawData =
  let
    title =
      getRawData "TITLE" rawData
        |> List.head

    artist =
      getRawData "ARTIST" rawData
        |> List.head

    genres =
      getRawData "GENRE" rawData

    comment =
      getRawData "COMMENTS" rawData
        |> List.head
  in
  { title = title
  , artist = artist
  , genres = genres
  , comment = comment
  , bpm = bpm
  }