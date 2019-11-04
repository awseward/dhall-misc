let CronExpr = ../CronExpr/Type.dhall

in  { Type = { when : CronExpr.Type, what : Text, enabled : Bool }
    , default = { when = CronExpr::{=}, enabled = True }
    }
