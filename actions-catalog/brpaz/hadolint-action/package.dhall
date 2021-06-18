let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "hadolint/hadolint-action"
            "v1.5.0"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
