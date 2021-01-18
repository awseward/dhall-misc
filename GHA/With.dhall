let imports = ./imports.dhall

let JSON = imports.Prelude.JSON

let Map = imports.Prelude.Map

let empty = Map.empty Text JSON.Type

in  { Type = Map.Type Text JSON.Type, default = empty, empty }
