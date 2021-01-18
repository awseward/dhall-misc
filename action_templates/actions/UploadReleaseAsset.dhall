let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let GHA = ../../GHA/package.dhall

let name = "actions/upload-release-asset"

let version = "v1"

let Inputs =
      let T =
            { asset_content_type : Text
            , asset_name : Text
            , asset_path : Text
            , upload_url : Text
            }

      let string = JSON.string

      in  { Type = T
          , default = {=}
          , toJSON =
              λ(inputs : T) →
                toMap
                  { asset_content_type = string inputs.asset_content_type
                  , asset_name = string inputs.asset_name
                  , asset_path = string inputs.asset_path
                  , upload_url = string inputs.upload_url
                  }
          }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
