let Prelude = (../imports.dhall).Prelude

let CronExpr = ../CronExpr/Type.dhall

let CronExpr/show = ../CronExpr/show.dhall

let CronJob = ./Type.dhall

let show =
      λ(job : CronJob.Type) →
        Prelude.Text.concatSep " " [ CronExpr/show job.when, job.what ]

let _example =
      let job =
              { when = CronExpr::{=}, what = "foo", enabled = True }
            : CronJob.Type

      let _ = assert : show job ≡ "* * * * * foo"

      in  {}

in  show
