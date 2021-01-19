let imports = ../imports.dhall

let JSON = imports.Prelude.JSON

let GHA = ../../GHA/package.dhall

let Inputs =
      let T = { dockerfile : Optional Text }

      let j =
            let opt =
                  λ(a : Type) →
                  λ(f : a → JSON.Type) →
                  λ(x : Optional a) →
                    merge { None = JSON.null, Some = f } x

            in  JSON ⫽ { stringOpt = opt Text JSON.string }

      in  { Type = T
          , default.dockerfile = None Text
          , toJSON =
              λ(inputs : T) →
                toMap { dockerfile = j.stringOpt inputs.dockerfile }
          }

let mkStep/next = GHA.actions.mkStep/next Inputs.Type Inputs.{ toJSON }

let mkStep = mkStep/next "brpaz/hadolint-action" "v1.2.1"

in  { mkStep, mkStep/next, Inputs } ⫽ GHA.Step.{ Common }
