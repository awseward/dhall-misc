let imports = ../imports.dhall

let JSON = imports.Prelude.JSON

let Map = imports.Map

let GHA = ../../GHA/package.dhall

let name = "brpaz/hadolint-action"

let version = "v1.2.1"

let Inputs =
      let T = { dockerfile : Optional Text }

      in  { Type = T
          , default.dockerfile = None Text
          , toJSON =
              λ(inputs : T) →
                toMap
                  { dockerfile =
                      merge
                        { None = JSON.null, Some = JSON.string }
                        inputs.dockerfile
                  }
          }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
