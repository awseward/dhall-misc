let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "actions/upload-artifact"
            "v2.2.2"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
