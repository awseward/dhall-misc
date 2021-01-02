let Checkout = ../actions/Checkout.dhall

let GHA = ../../GHA/package.dhall

let Job = GHA.Job

let mkRun = GHA.Step.mkRun

let Common = GHA.Step.Common

let Setup = ./Setup.dhall

let Opts =
      { Type =
          { platforms : List Text
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
              , [ run "nimble install --accept nimassets"
                , run "nimble ${opts.nimbleFlags} assets"
                , run "git diff --exit-code --color"
                ]
              ]
        }

let mkJobEntry =
      λ(opts : Opts.Type) → { mapKey = "check-assets", mapValue = mkJob opts }

let mkBasicJob = λ(platforms : List Text) → mkJob Opts::{ platforms }

let mkBasicJobEntry = λ(platforms : List Text) → mkJobEntry Opts::{ platforms }

in  { mkJob, mkJobEntry, mkBasicJob, mkBasicJobEntry, Opts, Setup }
