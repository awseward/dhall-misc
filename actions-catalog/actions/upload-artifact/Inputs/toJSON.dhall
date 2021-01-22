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
              { if-no-files-found = j.stringOpt inputs.if-no-files-found
              , name = j.stringOpt inputs.name
              , path = j.string inputs.path
              , retention-days = j.natural inputs.retention-days
              }

in  toJSON
