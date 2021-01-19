let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let GHA = ../../GHA/package.dhall

let Inputs =
      let T = { path : Text, key : Text, restore-keys : Optional Text }

      let j =
            let opt =
                  λ(a : Type) →
                  λ(f : a → JSON.Type) →
                  λ(x : Optional a) →
                    merge { None = JSON.null, Some = f } x

            in  JSON ⫽ { stringOpt = opt Text JSON.string }

      let toJSON =
            λ(inputs : T) →
              toMap
                { path = j.string inputs.path
                , key = j.string inputs.key
                , restore-keys = j.stringOpt inputs.restore-keys
                }

      in  { Type = T, default.restore-keys = None Text, toJSON }

let mkStep/next = GHA.actions.mkStep/next Inputs.Type Inputs.{ toJSON }

let mkStep = mkStep/next "actions/cache" "v1"

in  { mkStep, mkStep/next, Inputs } ⫽ GHA.Step.{ Common }
