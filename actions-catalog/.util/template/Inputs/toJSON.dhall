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
              { _example1 = j.null
              , _example2 =
                  j.string "inputs.something, but not in a literal like this"
              , _example3 =
                  j.stringOpt (Some "j here is an extendsion on Prelude.JSON")
              }

in  toJSON
