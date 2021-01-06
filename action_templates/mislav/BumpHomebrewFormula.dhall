let imports = ../imports.dhall

let Prelude = imports.Prelude

let GHA = ../../GHA/package.dhall

let name = "mislav/bump-homebrew-formula-action"

let version = "v1"

let Inputs =
      { Type =
          { base-branch : Optional Text
          , commit-message : Optional Text
          , download-url : Optional Text
          , formula-name : Optional Text
          , homebrew-tap : Optional Text
          }
      , default = {=}
      }

let mkStep =
      GHA.actions.mkStep
        name
        version
        Inputs.Type
        ( λ(inputs : Inputs.Type) →
            Prelude.Map.unpackOptionals Text Text (toMap inputs)
        )

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
