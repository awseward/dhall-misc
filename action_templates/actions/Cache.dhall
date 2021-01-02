let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let With = { Type = { path : Text, key : Text }, default = {=} }

let step =
      λ(common : Step.Common.Type) →
      λ(`with` : With.Type) →
        Step.mkUses
          common
          Step.Uses::{ uses = "actions/cache@v1", `with` = toMap `with` }

in  { step, With }
