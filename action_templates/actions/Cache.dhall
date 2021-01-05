let imports = ../imports.dhall

let Prelude = imports.Prelude

let GHA = ../../GHA/package.dhall

let name = "actions/cache"

let version = "v1"

let Inputs =
      { Type = { path : Text, key : Text, restore-keys : Optional Text }
      , default.restore-keys = None Text
      }

let inputsToMap =
      λ(inputs : Inputs.Type) →
        let homogenized =
              inputs ⫽ { path = Some inputs.path, key = Some inputs.key }

        in  Prelude.Map.unpackOptionals Text Text (toMap homogenized)

let mkStep =
      GHA.actions.mkStep
        name
        version
        Inputs.Type
        (λ(inputs : Inputs.Type) → inputsToMap inputs)

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
