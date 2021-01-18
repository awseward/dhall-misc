let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let name = "actions/checkout"

let version = "v2"

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
                let orNull = Prelude.Optional.default JSON.Type JSON.null

                let optMapJSON =
                      λ(a : Type) →
                      λ(f : a → JSON.Type) →
                        Prelude.Optional.map a JSON.Type f

                let optJSON =
                      λ(a : Type) →
                      λ(f : a → JSON.Type) →
                      λ(x : Optional a) →
                        orNull (optMapJSON a f x)

                let fromText = optJSON Text JSON.string

                let fromBool = optJSON Bool JSON.bool

                let fromNatural = optJSON Natural JSON.natural

                in  toMap
                      { repository = fromText inputs.repository
                      , ref = fromText inputs.ref
                      , token = fromText inputs.token
                      , ssh-key = fromText inputs.ssh-key
                      , ssh-known-hosts = fromText inputs.ssh-key
                      , ssh-strict = fromBool inputs.ssh-strict
                      , persist-credentials =
                          fromBool inputs.persist-credentials
                      , path = fromText inputs.path
                      , clean = fromBool inputs.clean
                      , fetch-depth = fromNatural inputs.fetch-depth
                      , lfs = fromBool inputs.lfs
                      , submodules = fromBool inputs.submodules
                      }
          }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

let do =
      λ(checkout : Step.Type) →
      λ(subsequent : List Step.Type) →
        [ checkout ] # subsequent

let plain = mkStep Step.Common::{=} Inputs::{=}

let plainDo = do plain

in  { do, plain, plainDo, mkStep, Inputs } ⫽ GHA.Step.{ Common }
