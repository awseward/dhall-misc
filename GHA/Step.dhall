let imports = ./imports.dhall

let JSON = imports.Prelude.JSON

let Env = ./Env.dhall

let With = ./With.dhall

let subst = ./subst.dhall

let Common =
      { Type =
          { id : Optional Text
          , `if` : Optional Text
          , name : Optional Text
          , env : Env.Type
          , continue-on-error : Optional Bool
          , timeout-minutes : Optional Natural
          }
      , default =
        { id = None Text
        , `if` = None Text
        , name = None Text
        , env = Env.empty
        , continue-on-error = None Bool
        , timeout-minutes = None Natural
        }
      }

let Uses =
      { Type = { uses : Text, `with` : With.Type }
      , default.`with` = With.empty
      }

let Step =
      { Type =
            Common.Type
          ⩓ { run : Optional Text }
          ⩓ { uses : Optional Text, `with` : With.Type }
      , default =
            Common.default
          ⫽ { uses = None Text, run = None Text, `with` = With.empty }
      }

let mkRun =
      λ(common : Common.Type) →
      λ(run : Text) →
        Step::(common ⫽ { run = Some run })

let _ =
        assert
      :   mkRun Common::{ id = Some "test" } "echo 'hi'"
        ≡ Step::{
          , run = Some "echo 'hi'"
          , id = Some "test"
          , uses = None Text
          , `with` = With.empty
          }

let mkUses =
      λ(common : Common.Type) →
      λ(uses : Uses.Type) →
        let uses_ = uses ⫽ { uses = Some uses.uses } in Step::(common ⫽ uses_)

let _ =
        assert
      :   mkUses
            Common::{ id = Some "test" }
            Uses::{
            , uses = "foo/bar@v1"
            , `with` = toMap { answer = JSON.bool True }
            }
        ≡ Step::{
          , run = None Text
          , id = Some "test"
          , uses = Some "foo/bar@v1"
          , `with` = toMap { answer = JSON.bool True }
          }

let concat = imports.Prelude.List.concat Step.Type

let substOutput =
      λ(stepId : Text) →
      λ(name : Text) →
        subst "steps.${stepId}.outputs.${name}"

let export = Step ⫽ { Common, Uses, mkRun, mkUses, concat, substOutput }

let _ = assert : export.Uses.default ≡ Uses.default

in  export
