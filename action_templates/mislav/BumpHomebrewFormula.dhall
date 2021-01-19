let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let GHA = ../../GHA/package.dhall

let name = "mislav/bump-homebrew-formula-action"

let version = "v1"

let Inputs =
      let T =
            { base-branch : Optional Text
            , commit-message : Optional Text
            , download-url : Optional Text
            , formula-name : Optional Text
            , homebrew-tap : Optional Text
            }

      let j =
            let opt =
                  λ(a : Type) →
                  λ(f : a → JSON.Type) →
                  λ(x : Optional a) →
                    merge { None = JSON.null, Some = f } x

            in  JSON ⫽ { stringOpt = opt Text JSON.string }

      in  { Type = T
          , default = {=}
          , toJSON =
              λ(inputs : T) →
                toMap
                  { base-branch = j.stringOpt inputs.base-branch
                  , commit-message = j.stringOpt inputs.commit-message
                  , download-url = j.stringOpt inputs.download-url
                  , formula-name = j.stringOpt inputs.formula-name
                  , homebrew-tap = j.stringOpt inputs.homebrew-tap
                  }
          }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
