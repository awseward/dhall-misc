{-

Generated via:

  curl -s 'https://raw.githubusercontent.com/actions/upload-artifact/v2.2.2/action.yml' | yaml-to-dhall ./foo.dhall --records-loose > parsed.dhall

-}
--
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
      , description =
          "A file, directory or wildcard pattern that describes what to upload"
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
      , description = "Artifact name"
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
      , description =
          ''
          The desired behavior if no files are found using the provided path.
          Available Options:
            warn: Output a warning but do not fail the action
            error: Fail the action with an error message
            ignore: Do not output any warnings or errors, the action does not fail
          ''
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
      , description =
          ''
          Duration after which artifact will expire in days. 0 means using default retention.
          Minimum 1 day. Maximum 90 days unless changed from the repository settings page.
          ''
      , required = None Bool
      }
    }
}
