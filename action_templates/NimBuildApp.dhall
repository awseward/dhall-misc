-- NOTE: The "calling" code is the `in` part of this file. It's based on what's
--       currently in https://github.com/awseward/call_status/blob/66ed79f733a9f4d78758bb16bbf96575cf6a7f38/.github/workflows/ci.yml#L35-L77
--
let GHA =
      let With =
            { Type =
                { path : Optional Text
                , key : Optional Text
                , nim-version : Optional Text
                }
            , default =
              { path = None Text, key = None Text, nim-version = None Text }
            }

      let Uses =
            { Type =
                { name : Optional Text
                , uses : Text
                , id : Optional Text
                , `with` : Optional With.Type
                }
            , default =
              { name = None Text, id = None Text, `with` = None With.Type }
            }

      let Run = { Type = { run : Text }, default.run = "FIXME" }

      let Step = < uses : Uses.Type | run : Run.Type >

      in  { With, Uses, Run, Step }

let uses = GHA.Step.uses

let run = GHA.Step.run

let NimBuildApp =
      { Type =
          { platforms : List Text
          , bin : Text
          , nimVersion : Text
          , setupNimAction : Text
          , setupNimActionVersion : Text
          , nimbleBuildFlags : Text
          }
      , default =
        { nimVersion = "1.4.2"
        , setupNimAction = "jiro4989/setup-nim-action"
        , setupNimActionVersion = "1.2.3"
        , nimbleBuildFlags = ""
        }
      }

let mkAction =
      λ(nba : NimBuildApp.Type) →
        { mapKey = "build-${nba.bin}"
        , mapValue =
          { runs-on = nba.platforms
          , steps =
                [ uses GHA.Uses::{ uses = "actions/checkout@v2" }
                , uses
                    GHA.Uses::{
                    , name = Some "Cache choosenim"
                    , uses = "actions/cache@v1"
                    , id = Some "cache-choosenim"
                    , `with` = Some GHA.With::{
                      , path = Some "~/.choosenim"
                      , key = Some "\${{ runner.os }}-choosenim"
                      }
                    }
                , uses
                    GHA.Uses::{
                    , name = Some "Cache nimble"
                    , uses = "actions/cache@v1"
                    , id = Some "cache-nimble"
                    , `with` = Some GHA.With::{
                      , path = Some "~/.nimble"
                      , key = Some "\${{ runner.os }}-nimble"
                      }
                    }
                , uses
                    GHA.Uses::{
                    , uses =
                        "${nba.setupNimAction}@${nba.setupNimActionVersion}"
                    , `with` = Some GHA.With::{
                      , nim-version = Some "${nba.nimVersion}"
                      }
                    }
                , run
                    GHA.Run::{
                    , run =
                        "nimble --stacktrace:on --linetrace:on ${nba.nimbleBuildFlags} build --accept ${nba.bin}"
                    }
                ]
              : List GHA.Step
          }
        }

in  [ mkAction
        NimBuildApp::{
        , platforms = [ "ubuntu-latest" ]
        , bin = "web"
        , nimVersion = "1.4.0"
        , nimbleBuildFlags = "--define:release --define:useStdLib"
        }
    , mkAction
        NimBuildApp::{
        , platforms = [ "macos-latest" ]
        , bin = "call_status_checker"
        , nimbleBuildFlags = "--define:release --define:ssl"
        }
    ]
