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

              in    JSON
                  ⫽ { boolOpt = opt Bool JSON.bool
                    , stringOpt = opt Text JSON.string
                    }

        in  toMap
              { nim-version = j.stringOpt inputs.nim-version
              , no-color = j.boolOpt inputs.no-color
              , yes = j.boolOpt inputs.yes
              }

in  toJSON
