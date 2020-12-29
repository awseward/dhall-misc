-- FIXME: `With` is probably better done some other way...
let With =
      { Type =
          { path : Optional Text
          , key : Optional Text
          , nim-version : Optional Text
          }
      , default = { path = None Text, key = None Text, nim-version = None Text }
      }

let Uses =
      { Type =
          { name : Optional Text
          , uses : Text
          , id : Optional Text
          , `with` : Optional With.Type
          }
      , default = { name = None Text, id = None Text, `with` = None With.Type }
      }

let Run = { Type = { run : Text }, default.run = "FIXME" }

let Step = < uses : Uses.Type | run : Run.Type >

in  { With, Uses, Run, Step }
