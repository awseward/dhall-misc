let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
        let j = JSON

        in  toMap
              { asset_content_type = j.string inputs.asset_content_type
              , asset_name = j.string inputs.asset_name
              , asset_path = j.string inputs.asset_path
              , upload_url = j.string inputs.upload_url
              }

in  toJSON
