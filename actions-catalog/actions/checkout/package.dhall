let GHA = (../../imports.dhall).GHA

let Inputs = ./Inputs/package.dhall

let Step = GHA.Step

let mkStep =
      GHA.actions.mkStep/next
        Inputs.Type
        Inputs.{ toJSON }
        "actions/checkout"
        "v2"

let do =
      let f = λ(a : Type) → λ(x : a) → λ(xs : List a) → [ x ] # xs

      in  f Step.Type

let plain = mkStep Step.Common::{=} Inputs::{=}

in  { mkStep, Inputs, do, plain, plainDo = do plain } ⫽ GHA.Step.{ Common }
