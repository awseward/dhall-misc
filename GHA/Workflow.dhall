let imports = ./imports.dhall

let Defaults = ./Defaults.dhall

let Env = ./Env.dhall

let Job = ./Job.dhall

let Map = imports.Map

let On = ./On.dhall

in  { Type =
        { name : Text
        , on : On.Type
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
