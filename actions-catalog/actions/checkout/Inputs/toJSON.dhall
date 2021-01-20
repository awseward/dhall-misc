let imports = ../../../imports.dhall

let JSON = imports.JSON

let Map = imports.Prelude.Map

let Inputs = ./Type.dhall

let toJSON
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
        let j = JSON

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
