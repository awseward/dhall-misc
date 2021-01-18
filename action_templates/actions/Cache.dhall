let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let GHA = ../../GHA/package.dhall

let name = "actions/cache"

let version = "v1"

let Inputs =
      let T = { path : Text, key : Text, restore-keys : Optional Text }

      let toJSON =
            λ(inputs : T) →
              Map.map
                Text
                Text
                JSON.Type
                JSON.string
                ( Prelude.Map.unpackOptionals
                    Text
                    Text
                    ( toMap
                        (   inputs
                          ⫽ { path = Some inputs.path, key = Some inputs.key }
                        )
                    )
                )

      in  { Type = T, default.restore-keys = None Text, toJSON }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
