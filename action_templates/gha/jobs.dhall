let Map = (../imports.dhall).Map

let Uses =
      { Type =
          { name : Optional Text
          , uses : Text
          , id : Optional Text
          , `with` : Map.Type Text Text
          }
      , default =
        { name = None Text, id = None Text, `with` = Map.empty Text Text }
      }

let Run = { Type = { run : Text }, default.run = "FIXME" }

let Step = < uses : Uses.Type | run : Run.Type >

in  { Uses, Run, Step }
