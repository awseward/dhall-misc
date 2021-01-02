let GHA = ../../GHA/package.dhall

let Cache = ../actions/Cache.dhall

let mkUses = GHA.Step.mkUses

let Common = GHA.Step.Common

let Uses = GHA.Step.Uses

let Opts =
      { Type =
          { nimVersion : Text, setupAction : Text, setupActionVersion : Text }
      , default =
        { nimVersion = "1.4.2"
        , setupAction = "jiro4989/setup-nim-action"
        , setupActionVersion = "v1.2.3"
        }
      }

let mkSteps =
      λ(opts : Opts.Type) →
        [ Cache.step
            Common::{
            , name = Some "Cache choosenim"
            , id = Some "cache-choosenim"
            }
            Cache.With::{
            , path = "~/.choosenim"
            , key = "\${{ runner.os }}-choosenim"
            }
        , Cache.step
            Common::{
            , name = Some "Cache choosenim"
            , id = Some "cache-choosenim"
            }
            Cache.With::{
            , path = "~/.choosenim"
            , key = "\${{ runner.os }}-choosenim"
            }
        , mkUses
            Common::{=}
            Uses::{
            , uses = "${opts.setupAction}@${opts.setupActionVersion}"
            , `with` = toMap { nim-version = "${opts.nimVersion}" }
            }
        ]

in  { mkSteps, Opts }
