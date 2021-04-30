let Checkout = ../actions/Checkout.dhall

let GHA = ../../GHA/package.dhall

let Common = GHA.Step.Common

let Job = GHA.Job

let mkRun = GHA.Step.mkRun

let OS = GHA.OS.Type

let Setup = ./Setup.dhall

let Opts =
      { Type =
          { platforms : List OS
          , nimSetup : Setup.Opts.Type
          , nimbleFlags : Text
          }
      , default = { nimSetup = Setup.Opts::{=}, nimbleFlags = "" }
      }

let run = mkRun Common::{=}

let mkJob =
      λ(opts : Opts.Type) →
        Job::{
        , runs-on = opts.platforms
        , steps =
            Checkout.plainDo
              (   Setup.mkSteps opts.nimSetup
                # [ run "nimble ${opts.nimbleFlags} docs" ]
              )
        }

let mkJobEntry =
      λ(opts : Opts.Type) → { mapKey = "generate-docs", mapValue = mkJob opts }

let mkBasicJob = λ(platforms : List OS) → mkJob Opts::{ platforms }

let mkBasicJobEntry = λ(platforms : List OS) → mkJobEntry Opts::{ platforms }

in  { mkJob, mkJobEntry, mkBasicJob, mkBasicJobEntry, Opts, Setup }
