let Text/concatSep =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Text/concatSep
        sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let CronExpr = ../CronExpr/Type.dhall

let CronExpr/show = ../CronExpr/show.dhall

let CronJob = ./Type.dhall

let show =
      λ(job : CronJob.Type) →
        Text/concatSep " " [ CronExpr/show job.when, job.what ]

let _example =
      let job =
              { when = CronExpr::{=}, what = "foo", enabled = True }
            : CronJob.Type

      let _ = assert : show job ≡ "* * * * * foo"

      in  {}

in  show
