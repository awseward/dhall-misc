let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "mxschmitt/action-tmate"
            "v3.1"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
