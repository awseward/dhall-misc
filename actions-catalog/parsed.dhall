{-

Generated via:

  curl -s 'https://raw.githubusercontent.com/actions/upload-artifact/v2.2.2/action.yml' | yaml-to-dhall ./foo.dhall --records-loose > parsed.dhall

-}
{ inputs = toMap
    { path =
      { default =
          None
            ( Type →
              { array : List _ → _@1
              , bool : Bool → _@1
              , double : Double → _@1
              , integer : Integer → _@1
              , null : _
              , object : List { mapKey : Text, mapValue : _ } → _@1
              , string : Text → _@1
              } →
                _@1
            )
      , required = Some True
      }
    , name =
      { default = Some
          ( λ(JSON : Type) →
            λ ( json
              : { array : List JSON → JSON
                , bool : Bool → JSON
                , double : Double → JSON
                , integer : Integer → JSON
                , null : JSON
                , object : List { mapKey : Text, mapValue : JSON } → JSON
                , string : Text → JSON
                }
              ) →
              json.string "artifact"
          )
      , required = None Bool
      }
    , if-no-files-found =
      { default = Some
          ( λ(JSON : Type) →
            λ ( json
              : { array : List JSON → JSON
                , bool : Bool → JSON
                , double : Double → JSON
                , integer : Integer → JSON
                , null : JSON
                , object : List { mapKey : Text, mapValue : JSON } → JSON
                , string : Text → JSON
                }
              ) →
              json.string "warn"
          )
      , required = None Bool
      }
    , retention-days =
      { default =
          None
            ( Type →
              { array : List _ → _@1
              , bool : Bool → _@1
              , double : Double → _@1
              , integer : Integer → _@1
              , null : _
              , object : List { mapKey : Text, mapValue : _ } → _@1
              , string : Text → _@1
              } →
                _@1
            )
      , required = None Bool
      }
    }
}
