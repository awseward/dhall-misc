-- Based on: https://github.com/EarnestResearch/dhall-packages/tree/v0.11.1/util/CronTab
let CronExpr =
      https://raw.githubusercontent.com/EarnestResearch/dhall-packages/v0.11.1/util/CronTab/package.dhall sha256:e6a2fd6070196abc24cf0e4f77100a972710075ac43458ff09bf0619abb45ddc

in  { Type = CronExpr.Type, default = CronExpr.default }
