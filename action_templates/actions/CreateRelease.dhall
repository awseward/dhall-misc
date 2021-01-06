let imports = ../imports.dhall

let Prelude = imports.Prelude

let GHA = ../../GHA/package.dhall

let name = "actions/create-release"

let version = "v1"

let Body = < text : Text | path : Text >

let Inputs =
      { Type =
          { tag_name : Text
          , release_name : Text
          , body : Body
          , draft : Optional Bool
          , prerelease : Optional Bool
          , commitish : Optional Text
          , owner : Optional Text
          , repo : Optional Text
          }
      , default =
        { draft = None Bool
        , prerelease = None Bool
        , commitish = None Text
        , owner = None Text
        , repo = None Text
        }
      }

let boolMapShow =
      Prelude.Optional.map
        Bool
        Text
        ( λ(bool : Bool) →
            Text/replace "T" "t" (Text/replace "F" "f" (Prelude.Bool.show bool))
        )

let inputsToMap =
      λ(inputs : Inputs.Type) →
        let homogenized =
                inputs
              ⫽ { tag_name = Some inputs.tag_name
                , release_name = Some inputs.release_name
                , draft = boolMapShow inputs.draft
                , prerelease = boolMapShow inputs.prerelease
                }
              ⫽ merge
                  { text =
                      λ(body : Text) →
                        { body = Some body, body_path = None Text }
                  , path =
                      λ(path : Text) →
                        { body = None Text, body_path = Some path }
                  }
                  inputs.body

        in  Prelude.Map.unpackOptionals Text Text (toMap homogenized)

let mkStep =
      GHA.actions.mkStep
        name
        version
        Inputs.Type
        (λ(inputs : Inputs.Type) → inputsToMap inputs)

in  { mkStep, Inputs, Body } ⫽ GHA.Step.{ Common }
