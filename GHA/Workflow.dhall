{-

TODO Get `on` properly typed and working

  There's kind of a lot to it, so I'm just leaving it plainly as Text for now.
  For the complexity, see the following fragments on the API reference page

  https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions:
    - #on
    - #onevent_nametypes
    - #onpushpull_requestbranchestags
    - #onpushpull_requestpaths
    - #onschedule

-}
let imports = ./imports.dhall

let Defaults = ./Defaults.dhall

let Env = ./Env.dhall

let Job = ./Job.dhall

let Map = imports.Map

in  { Type =
        { name : Text
        , on : Text
        , env : Env.Type
        , defaults : Defaults.Type
        , jobs : Map.Type Text Job.Type
        }
    , default =
      { env = Env.empty
      , defaults = Defaults.empty
      , jobs = Map.empty Text Job.Type
      }
    }
