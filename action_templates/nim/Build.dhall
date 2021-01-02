let Checkout = ../actions/Checkout.dhall

let GHA = ../../GHA/package.dhall

let Job = GHA.Job

let mkRun = GHA.Step.mkRun

let Common = GHA.Step.Common

let Setup = ./Setup.dhall

let Opts =
      { Type =
          { platforms : List Text
          , bin : Text
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
              [ Setup.mkSteps opts.nimSetup
              , [ run
                    "nimble --stacktrace:on --linetrace:on ${opts.nimbleFlags} build --accept ${opts.bin}"
                ]
              ]
        }

let mkJobEntry =
      λ(opts : Opts.Type) →
        { mapKey = "build-${opts.bin}", mapValue = mkJob opts }

in  { mkJob, mkJobEntry, Opts, Setup }
