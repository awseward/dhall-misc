let imports = ../imports.dhall

let Checkout = ../actions/Checkout.dhall

let GHA = ../../GHA/package.dhall

let Job = GHA.Job

let mkRun = GHA.Step.mkRun

let Common = GHA.Step.Common

let OS = GHA.OS.Type

let Setup = ./Setup.dhall

let Opts =
      { Type =
          { platforms : List OS
          , bin : Text
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
                # [ run
                      "nimble --stacktrace:on --linetrace:on ${opts.nimbleFlags} build --accept ${opts.bin}"
                  ]
              )
        }

let mkJobEntry =
      λ(opts : Opts.Type) →
        { mapKey = "build-${opts.bin}", mapValue = mkJob opts }

let _ =
      let runs
          : GHA.Job.Type → List Text
          = let steps = λ(j : GHA.Job.Type) → j.steps

            let run = λ(s : GHA.Step.Type) → s.run

            let chooseRuns
                : List GHA.Step.Type → List Text
                = imports.Prelude.Function.compose
                    (List GHA.Step.Type)
                    (List (Optional Text))
                    (List Text)
                    (imports.Prelude.List.map GHA.Step.Type (Optional Text) run)
                    (imports.Prelude.List.unpackOptionals Text)

            in  imports.Prelude.Function.compose
                  GHA.Job.Type
                  (List GHA.Step.Type)
                  (List Text)
                  steps
                  chooseRuns

      let job = mkJob Opts::{ bin = "foobar", platforms = [ OS.ubuntu-latest ] }

      in    assert
          :   runs job
            ≡ [ "nimble --stacktrace:on --linetrace:on build --accept foobar" ]

in  { mkJob, mkJobEntry, Opts, Setup }
