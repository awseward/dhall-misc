let CronJob = ../CronJob/Type.dhall

in  { Type =
        { HOME : Optional Text
        , LOGNAME : Optional Text
        , MAILTO : Optional Text
        , SHELL : Optional Text
        , jobs : List CronJob.Type
        }
    , default =
        { SHELL = None Text
        , LOGNAME = None Text
        , MAILTO = None Text
        , HOME = None Text
        }
    }
