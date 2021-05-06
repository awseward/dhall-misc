let imports = ../imports.dhall

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

let run =
      let fixSpaces = imports.Prelude.Text.replace "  " " "

      in  λ(str : Text) → mkRun Common::{=} (fixSpaces str)

let mkJob =
      λ(opts : Opts.Type) →
        Job::{
        , runs-on = opts.platforms
        , steps =
            Checkout.plainDo
              (   Setup.mkSteps opts.nimSetup
                # [ run "nimble ${opts.nimbleFlags} assets"
                  , run "git diff --exit-code --color"
                  ]
              )
        }

let mkJobEntry =
      λ(opts : Opts.Type) → { mapKey = "check-assets", mapValue = mkJob opts }

let mkBasicJob = λ(platforms : List OS) → mkJob Opts::{ platforms }

let mkBasicJobEntry = λ(platforms : List OS) → mkJobEntry Opts::{ platforms }

let _ =
      let runs
          : GHA.Job.Type → List Text
          = λ(job : GHA.Job.Type) →
              imports.Prelude.List.unpackOptionals
                Text
                ( imports.Prelude.List.map
                    GHA.Step.Type
                    (Optional Text)
                    (λ(step : GHA.Step.Type) → step.run)
                    job.steps
                )

      in    assert
          :   runs (mkBasicJob [ OS.ubuntu-latest ])
            ≡ [ "nimble assets", "git diff --exit-code --color" ]

in  { mkJob, mkJobEntry, mkBasicJob, mkBasicJobEntry, Opts, Setup }
