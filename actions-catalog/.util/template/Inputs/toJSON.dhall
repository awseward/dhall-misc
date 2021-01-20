let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) → toMap {=} : Map.Type Text JSON.Type

in  toJSON
