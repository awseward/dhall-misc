let Prelude = (../imports.dhall).Prelude

let List/map = Prelude.List.map

let Text/concatSep = Prelude.Text.concatSep

let Optional/toList = Prelude.Optional.toList

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
