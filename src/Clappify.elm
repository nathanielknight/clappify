module Clappify exposing(main)

import String

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onInput, onClick)

---------------------------------------------------------------------

-- clapping hands emoji with Fitzpatrick modifiers
clap6 = "👏🏿"
clap5 = "👏🏾"
clap4 = "👏🏽"
clap3 = "👏🏼"
clap2 = "👏🏻"

type Clap = Clap2 | Clap3 | Clap4 | Clap5 | Clap6

clap_to_string c =
    case c of
        Clap6 -> clap6
        Clap5 -> clap5
        Clap4 -> clap4
        Clap3 -> clap3
        Clap2 -> clap2

next_clap c =
    case c of
        Clap6 -> Clap5
        Clap5 -> Clap4
        Clap4 -> Clap3
        Clap3 -> Clap2
        Clap2 -> Clap6

add_claps : List String -> Clap -> String -> String
add_claps words clap result =
    case words of
        w :: [] -> result ++ w
        w :: ws -> add_claps ws (next_clap clap) (String.concat [result, w, clap_to_string clap])
        [] -> result

clappify : String -> String
clappify s = add_claps (String.words s) Clap6 ""

---------------------------------------------------------------------

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
        span
            [style [ ("color", color)
                   , ("margin", "0.2em 0.3em")
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

statusbar_style =
    style [ ("font-size", "18px") ]

output_style =
    style [ ("font-size", "22px")
          , ("padding", "0.5em 0")
          , ("line-height", "110%")
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
        statusbar = div [ statusbar_style ]
                    [ charcount model
                    , button [onClick Clear
                             , style [ ("font-size", "16px")
                                     , ("float", "right")
                                     ]
                             ]
                        [text "Clear"]
                    ]
        outputbox = div [id "display-box", output_style] [text <| clappify model]
        sourcelink =
            p
            []
            [ a [ href "https://github.com/neganp/clappify"
                , target "blank"
                ]
                  [ text "source code" ]
            ]
    in
        div [ page_style ]
            [ h1 [] [text "clappifier"]
            , sourcelink
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
