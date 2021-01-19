let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let Inputs =
      let T =
            { repository : Optional Text
            , ref : Optional Text
            , token : Optional Text
            , ssh-key : Optional Text
            , ssh-known-hosts : Optional Text
            , ssh-strict : Optional Bool
            , persist-credentials : Optional Bool
            , path : Optional Text
            , clean : Optional Bool
            , fetch-depth : Optional Natural
            , lfs : Optional Bool
            , submodules : Optional Bool
            }

      let j =
            let opt =
                  λ(a : Type) →
                  λ(f : a → JSON.Type) →
                  λ(x : Optional a) →
                    merge { None = JSON.null, Some = f } x

            in    JSON
                ⫽ { boolOpt = opt Bool JSON.bool
                  , naturalOpt = opt Natural JSON.natural
                  , stringOpt = opt Text JSON.string
                  }

      in  { Type = T
          , default =
            { repository = None Text
            , ref = None Text
            , token = None Text
            , ssh-key = None Text
            , ssh-known-hosts = None Text
            , ssh-strict = None Bool
            , persist-credentials = None Bool
            , path = None Text
            , clean = None Bool
            , fetch-depth = None Natural
            , lfs = None Bool
            , submodules = None Bool
            }
          , toJSON =
              λ(inputs : T) →
                toMap
                  { repository = j.stringOpt inputs.repository
                  , ref = j.stringOpt inputs.ref
                  , token = j.stringOpt inputs.token
                  , ssh-key = j.stringOpt inputs.ssh-key
                  , ssh-known-hosts = j.stringOpt inputs.ssh-key
                  , ssh-strict = j.boolOpt inputs.ssh-strict
                  , persist-credentials = j.boolOpt inputs.persist-credentials
                  , path = j.stringOpt inputs.path
                  , clean = j.boolOpt inputs.clean
                  , fetch-depth = j.naturalOpt inputs.fetch-depth
                  , lfs = j.boolOpt inputs.lfs
                  , submodules = j.boolOpt inputs.submodules
                  }
          }

let mkStep/next = GHA.actions.mkStep/next Inputs.Type Inputs.{ toJSON }

let mkStep = mkStep/next "actions/checkout" "v2"

let do =
      λ(checkout : Step.Type) →
      λ(subsequent : List Step.Type) →
        [ checkout ] # subsequent

let plain = mkStep Step.Common::{=} Inputs::{=}

let plainDo = do plain

in  { do, plain, plainDo, mkStep, mkStep/next, Inputs } ⫽ GHA.Step.{ Common }
