let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = imports.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
        let j = JSON

        in  toMap
              { path = j.string inputs.path
              , key = j.string inputs.key
              , restore-keys = j.stringOpt inputs.restore-keys
              }

in  toJSON
