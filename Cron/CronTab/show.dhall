let List/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Text/concatSep =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let Optional/toList =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/Optional/toList sha256:d78f160c619119ef12389e48a629ce293d69f7624c8d016b7a4767ab400344c4

let CronJob = ../CronJob/Type.dhall

let CronJob/show = ../CronJob/show.dhall

let CronVars = ../CronVars.dhall

let CronTab = ./Type.dhall

let show =
      λ(tab : CronTab.Type) →
        let optsLines =
              Optional/toList
                Text
                (CronVars.tryShow (toMap tab.{ HOME, LOGNAME, MAILTO, SHELL }))

        let jobLines = List/map CronJob.Type Text CronJob/show tab.jobs

        in  Text/concatSep "\n" (optsLines # jobLines)

let _example =
      let CronExpr = ../CronExpr/Type.dhall

      let tab =
            CronTab::{
            , HOME = Some "asdf"
            , MAILTO = Some "foo@example.com"
            , jobs =
              [ CronJob::{
                , when = CronExpr::{ hour = "0" }
                , what = "happens every midnight"
                }
              , CronJob::{
                , when = CronExpr::{ minute = "0" }
                , what = "happens every minute"
                }
              ]
            }

      let expected =
            ''
            HOME=asdf
            MAILTO=foo@example.com
            * 0 * * * happens every midnight
            0 * * * * happens every minute''

      let _ = assert : show tab ≡ expected

      in  {}

in  show
