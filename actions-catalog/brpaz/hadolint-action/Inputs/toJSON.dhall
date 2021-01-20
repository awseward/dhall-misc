let imports = ../../../imports.dhall

let JSON = imports.JSON

let Inputs = ./Type.dhall

in  λ(inputs : Inputs) → toMap { dockerfile = JSON.stringOpt inputs.dockerfile }
