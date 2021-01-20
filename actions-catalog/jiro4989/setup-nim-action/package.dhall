let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

let mkStep =
      GHA.actions.mkStep/next
        Inputs.Type
        Inputs.{ toJSON }
        "jiro4989/setup-nim-action"
        "v1.2.3"

in  { mkStep, Inputs } ⫽ GHA.Step.{ Common }
