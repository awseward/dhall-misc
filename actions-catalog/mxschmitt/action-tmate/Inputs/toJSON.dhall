let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = imports.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
        let j = JSON in toMap { sudo = j.boolOpt inputs.sudo }

in  toJSON
