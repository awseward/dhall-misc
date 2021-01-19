let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let GHA = ../../GHA/package.dhall

let Inputs =
      let T =
            { asset_content_type : Text
            , asset_name : Text
            , asset_path : Text
            , upload_url : Text
            }

      let j = JSON

      in  { Type = T
          , default = {=}
          , toJSON =
              λ(inputs : T) →
                toMap
                  { asset_content_type = j.string inputs.asset_content_type
                  , asset_name = j.string inputs.asset_name
                  , asset_path = j.string inputs.asset_path
                  , upload_url = j.string inputs.upload_url
                  }
          }

let mkStep/next = GHA.actions.mkStep/next Inputs.Type Inputs.{ toJSON }

let mkStep = mkStep/next "actions/upload-release-asset" "v1"

in  { mkStep, mkStep/next, Inputs } ⫽ GHA.Step.{ Common }
