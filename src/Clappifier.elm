module Main exposing(main)

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onInput, onClick)

---------------------------------------------------------------------

clappify : String -> String
clappify s = s
           |> String.words
           |> String.join "👏"

charcount : String -> Html Msg
charcount s =
    let
        n = String.length <| clappify s
        color = if n > 140 then
                    "red"
                else if n > 130 then
                    "yellow"
                else "black"
    in
        div
            [style [ ("color", color)
                   , ("float", "right")
                   ]
            ]
            [text <| toString n]

---------------------------------------------------------------------

page_style =
    style [ ("max-width", "33em")
          , ("margin", "auto")
          , ("font-family", "Arial, sans-serif")
          ]

input_box_style =
    style [ ("width", "90%")
          , ("height", "3em")
          , ("padding", "1em")
          , ("margin", "0")
          , ("font-family", "Arial, sans-serif")
          , ("font-size", "22px")
          , ("resize", "both")
          ]

output_style =
    style [ ("font-size", "22px")
          ]

---------------------------------------------------------------------

type alias Model = String
init_model = ""
    
type Msg = Clear
         | NewModel String

view : Model -> Html Msg
view model =
    let
        textbox = textarea
                  [ onInput NewModel
                  , input_box_style
                  , value model
                  ]
                  [text model]
        statusbar = div []
                    [ button [onClick Clear] [text "Clear"]
                    , charcount model
                    ]
        outputbox = div [id "display-box", output_style] [text <| clappify model]
    in
        div [ page_style ]
            [ h1 [] [text "clappify"]
            , textbox
            , statusbar
            , outputbox ]

update msg model =
    case msg of
        NewModel s -> s
        Clear -> ""

---------------------------------------------------------------------

main = beginnerProgram { model = init_model
                       , view = view
                       , update = update
                       }
