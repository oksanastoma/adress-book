port module Page.User exposing(..)
import Html exposing (..)

import Html exposing (Html, button, div, text, span, input, br)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main : Program Never Model Msg
main =
    Html.program
        { init = model
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

decodeModel : Model -> Msg
decodeModel model =
    LoadModel model

subscriptions : Model -> Sub Msg
subscriptions model =
    load decodeModel

port jsSave : Model -> Cmd msg
port jsLoad : () -> Cmd msg
port load : (Model -> msg) -> Sub msg

type alias Model =
    { users: List User
    , inputs:
        { email: String
        , name: String
        }
    }

type alias User =
    { username : String
    , email : String }

type Msg = Noop
    | AddUser
    | Change String
    | ChangeC String
    | RemoveTodo Int
    | SendToJs
    | LoadFromJs
    | LoadModel Model

init : Model
init = {
    users = [],
    inputs = { email = "", name = ""}
    }

model : (Model, Cmd Msg)
model = ({
    users = [],
    inputs = { email = "", name = ""}
    }, Cmd.none)


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        AddUser -> 
            let
                users = model.users
                new_model = { model | users = users ++ [User model.inputs.name model.inputs.email] }
            in
                (new_model, Cmd.none)
        Change s ->
            let inputs = model.inputs
                newInputs = { inputs | name = s}
                new_model = { model | inputs = newInputs }
            in
                (new_model, Cmd.none)
        ChangeC s ->
            let inputs = model.inputs
                newInputs = { inputs | email = s}
                new_model = { model | inputs = newInputs }
            in
                (new_model, Cmd.none)

        SendToJs ->
            ( model, jsSave model )
        
        LoadFromJs ->
            (model, jsLoad () )
        
        LoadModel stored_model ->
            (stored_model, Cmd.none)

        _ -> (model, Cmd.none) 
    
view : Model -> Html Msg
view model =
        span []
        [ input [ value model.inputs.name, placeholder "Name", onInput Change ] []
        , input [ value model.inputs.email, placeholder "email", onInput ChangeC ] [] 
        , button [ onClick AddUser ] [text "+"]
        , renderUsers model
        , button [onClick SendToJs] [text "Save"]
        , button [onClick LoadFromJs] [text "Open"]
        , button [onClick (LoadModel resetBook)] [text "Reset"]
        ]

resetBook : Model
resetBook = 
    {
        users = [],
        inputs = { email = "email@example.com", name = "User Name"}
    }
        

renderUsers : Model -> Html Msg
renderUsers model =
    div [] (List.map renderUser model.users)


renderUser : User -> Html Msg
renderUser user =
    span [] [ text (" " ++ user.username ++ " (" ++ user.email ++ ")"), br [][] ]
    