let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
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

        in  toMap
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

in  toJSON
