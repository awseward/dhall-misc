-- NOTE: The "calling" code is the `in` part of this file. It's based on what's
--       currently in https://github.com/awseward/call_status/blob/66ed79f733a9f4d78758bb16bbf96575cf6a7f38/.github/workflows/ci.yml#L35-L77
--
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

let With =
      { Type =
          { path : Optional Text
          , key : Optional Text
          , nim-version : Optional Text
          }
      , default = { path = None Text, key = None Text, nim-version = None Text }
      }

let Use =
      { Type =
          { name : Optional Text
          , uses : Text
          , id : Optional Text
          , `with` : Optional With.Type
          }
      , default = { name = None Text, id = None Text, `with` = None With.Type }
      }

let Run = { Type = { run : Text }, default.run = "FIXME" }

let Step = < use : Use.Type | run : Run.Type >

let mkAction =
      λ(nba : NimBuildApp.Type) →
        { mapKey = "build-${nba.bin}"
        , mapValue =
          { runs-on = nba.platforms
          , steps =
                [ Step.use Use::{ uses = "actions/checkout@v2" }
                , Step.use
                    Use::{
                    , name = Some "Cache choosenim"
                    , uses = "actions/cache@v1"
                    , id = Some "cache-choosenim"
                    , `with` = Some With::{
                      , path = Some "~/.choosenim"
                      , key = Some "\${{ runner.os }}-choosenim-stable"
                      }
                    }
                , Step.use
                    Use::{
                    , name = Some "Cache nimble"
                    , uses = "actions/cache@v1"
                    , id = Some "cache-nimble"
                    , `with` = Some With::{
                      , path = Some "~/.nimble"
                      , key = Some "\${{ runner.os }}-nimble-stable"
                      }
                    }
                , Step.use
                    Use::{
                    , uses =
                        "${nba.setupNimAction}@${nba.setupNimActionVersion}"
                    , `with` = Some With::{
                      , nim-version = Some "${nba.nimVersion}"
                      }
                    }
                , Step.run
                    Run::{
                    , run =
                        "nimble --stacktrace:on --linetrace:on ${nba.nimbleBuildFlags} build --accept ${nba.bin}"
                    }
                ]
              : List Step
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
