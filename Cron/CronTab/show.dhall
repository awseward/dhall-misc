let List/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let Text/concatSep =
      https://github.com/dhall-lang/dhall-lang/raw/master/Prelude/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let Optional/toList =
      https://github.com/dhall-lang/dhall-lang/raw/master/Prelude/Optional/toList sha256:390fe99619e9a25e71a253a2b33011f9e5fa26a7d990795205543d1edd72ce5b

let CronJob = ../CronJob/Type.dhall

let CronJob/show = ../CronJob/show.dhall

let CronVars = ../CronVars.dhall

let CronTab = ./Type.dhall

let show =
        λ(tab : CronTab.Type)
      → let optsLines =
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
      
      in  assert : show tab ≡ expected

in  show
