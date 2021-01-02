let GHA = ../../GHA/package.dhall

let Step = GHA.Step

in  Step.mkUses Step.Common::{=} Step.Uses::{ uses = "actions/checkout@v2" }
