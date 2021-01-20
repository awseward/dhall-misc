let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "brpaz/hadolint-action"
            "v1.2.1"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
