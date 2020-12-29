let GHA = ./jobs.dhall

let uses = GHA.Step.uses

in  { checkout = uses GHA.Uses::{ uses = "actions/checkout@v2" } }
