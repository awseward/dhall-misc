let GHA = ../../GHA/package.dhall

let name = "actions/upload-release-asset"

let version = "v1"

let Inputs =
      { Type =
          { asset_content_type : Text
          , asset_name : Text
          , asset_path : Text
          , upload_url : Text
          }
      , default = {=}
      }

let mkStep =
      GHA.actions.mkStep
        name
        version
        Inputs.Type
        (λ(inputs : Inputs.Type) → toMap inputs)

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
