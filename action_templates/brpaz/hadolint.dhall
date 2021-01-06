let imports = ../imports.dhall

let Map = imports.Map

let GHA = ../../GHA/package.dhall

let name = "brpaz/hadolint-action"

let version = "v1.2.1"

let Inputs =
      { Type = { dockerfile : Optional Text }, default.dockerfile = None Text }

let mkStep =
      GHA.actions.mkStep
        name
        version
        Inputs.Type
        (λ(inputs : Inputs.Type) → Map.unpackOptionals Text Text (toMap inputs))

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
