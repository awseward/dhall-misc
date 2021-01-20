let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
        let j =
              let opt =
                    λ(a : Type) →
                    λ(f : a → JSON.Type) →
                    λ(x : Optional a) →
                      merge { None = JSON.null, Some = f } x

              in  JSON ⫽ { stringOpt = opt Text JSON.string }

        in  toMap
              { path = j.string inputs.path
              , key = j.string inputs.key
              , restore-keys = j.stringOpt inputs.restore-keys
              }

in  toJSON
