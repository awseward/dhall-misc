let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "actions/create-release"
            "v1"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
