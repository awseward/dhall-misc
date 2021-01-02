let imports = ../imports.dhall

let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let concatStep = imports.concat Step.Type

let do =
      λ(checkout : Step.Type) →
      λ(subsequent : List (List Step.Type)) →
        concatStep [ [ checkout ], concatStep subsequent ]

let plain =
      Step.mkUses Step.Common::{=} Step.Uses::{ uses = "actions/checkout@v2" }

let plainDo = do plain

in  { do, plain, plainDo }
