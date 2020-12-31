let Map_ =
      let Map = (../imports.dhall).Map

      in  { Type = Map.Type Text Text, empty = Map.empty Text Text }

let Env = Map_

let With = Map_

let Common =
      { Type = { name : Optional Text, id : Optional Text, env : Env.Type }
      , default = { name = None Text, id = None Text, env = Env.empty }
      }

let Uses =
      { Type = Common.Type ⩓ { uses : Text, `with` : With.Type }
      , default = Common.default ⫽ { `with` = With.empty }
      }

let Run = { Type = Common.Type ⩓ { run : Text }, default = Common.default }

let Step = < uses : Uses.Type | run : Run.Type >

let _ =
        assert
      :   Run::{ id = Some "foo", run = "bar" }
        ≡ Common.default ⫽ { id = Some "foo", run = "bar" }

in  { Env, Run, Step, Uses, With }
