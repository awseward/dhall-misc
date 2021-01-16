let imports = ./imports.dhall

let JSON = imports.Prelude.JSON

let Matrix = ./Matrix.dhall

in  { Type = { matrix : JSON.Type }, default = {=}, Matrix }
