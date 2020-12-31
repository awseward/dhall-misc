let Map = (../imports.dhall).Map

let Map_ = Map.Type Text Text

let empty_ = Map.empty Text Text

let Common =
      { Type = { name : Optional Text, id : Optional Text, env : Map_ }
      , default = { name = None Text, id = None Text, env = empty_ }
      }

let Uses =
      { Type = Common.Type ⩓ { uses : Text, `with` : Map_ }
      , default = Common.default ⫽ { `with` = empty_ }
      }

let Run = { Type = Common.Type ⩓ { run : Text }, default = Common.default }

let Step = < uses : Uses.Type | run : Run.Type >

let _ =
        assert
      :   Run::{ id = Some "foo", run = "bar" }
        ≡ Common.default ⫽ { id = Some "foo", run = "bar" }

in  { Uses, Run, Step }
