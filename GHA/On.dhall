let imports = ./imports.dhall

let Map = imports.Map

let Types = { types : List Text }

let InEx = < include : List Text | ignore : List Text >

let PushPull =
      { Type =
          { branches : Optional InEx
          , tags : Optional InEx
          , paths : Optional InEx
          }
      , default = { branches = None InEx, tags = None InEx, paths = None InEx }
      }

let PushPull_ =
      { Type =
          { branches : List Text
          , branches-ignore : List Text
          , tags : List Text
          , tags-ignore : List Text
          , paths : List Text
          , paths-ignore : List Text
          }
      , default =
        { branches = [] : List Text
        , branches-ignore = [] : List Text
        , tags = [] : List Text
        , tags-ignore = [] : List Text
        , paths = [] : List Text
        , paths-ignore = [] : List Text
        }
      }

let fix =
      λ(pp : PushPull.Type) →
        let branches =
              λ(optInEx : Optional InEx) →
                merge
                  { None =
                    { branches = [] : List Text
                    , branches-ignore = [] : List Text
                    }
                  , Some =
                      λ(inEx : InEx) →
                        merge
                          { include =
                              λ(xs : List Text) →
                                { branches = xs
                                , branches-ignore = [] : List Text
                                }
                          , ignore =
                              λ(xs : List Text) →
                                { branches = [] : List Text
                                , branches-ignore = xs
                                }
                          }
                          inEx
                  }
                  optInEx

        let tags =
              λ(optInEx : Optional InEx) →
                merge
                  { None =
                    { tags = [] : List Text, tags-ignore = [] : List Text }
                  , Some =
                      λ(inEx : InEx) →
                        merge
                          { include =
                              λ(xs : List Text) →
                                { tags = xs, tags-ignore = [] : List Text }
                          , ignore =
                              λ(xs : List Text) →
                                { tags = [] : List Text, tags-ignore = xs }
                          }
                          inEx
                  }
                  optInEx

        let paths =
              λ(optInEx : Optional InEx) →
                merge
                  { None =
                    { paths = [] : List Text, paths-ignore = [] : List Text }
                  , Some =
                      λ(inEx : InEx) →
                        merge
                          { include =
                              λ(xs : List Text) →
                                { paths = xs, paths-ignore = [] : List Text }
                          , ignore =
                              λ(xs : List Text) →
                                { paths = [] : List Text, paths-ignore = xs }
                          }
                          inEx
                  }
                  optInEx

        in  branches pp.branches ⫽ tags pp.tags ⫽ paths pp.paths

let Schedule = { cron : Text }

let EventCfg =
      < types : Types | pushPull : PushPull_.Type | schedule : Schedule | null >

let Type_ = < name : Text | names : List Text | map : Map.Type Text EventCfg >

let _mkPushPull =
      λ(name : Text) →
      λ(cfg : PushPull.Type) →
        { mapKey = name, mapValue = EventCfg.pushPull (fix cfg) }

in  { _empty = Type_.map (Map.empty Text EventCfg)
    , _mkPushPull
    , include = λ(xs : List Text) → Some (InEx.include xs)
    , ignore = λ(xs : List Text) → Some (InEx.ignore xs)
    , map = Type_.map
    , name = Type_.name
    , names = Type_.names
    , null = EventCfg.null
    , pullRequest = _mkPushPull "pull_request"
    , push = _mkPushPull "push"
    , pushPull = EventCfg.pushPull
    , PushPull =
        PushPull ⫽ { InEx, include = InEx.include, ignore = InEx.ignore, fix }
    , Schedule
    , schedule = EventCfg.schedule
    , Type = Type_
    , Types
    , types = EventCfg.types
    }
