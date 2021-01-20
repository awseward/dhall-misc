let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "__owner__/__action__"
            "__tag__"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
