-- This is only the most basic of what `matrix` supports. What's missing:
--
--   * arbitrary keys & values
--   * include
--   * exclude
--
let imports = ./imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let OS_ = ./OS/package.dhall

let OS = OS_.Type

let OS/toJSON = OS_.toJSON

let CommonType =
      { os : List OS
      , fail-fast : Optional Bool
      , max-parallel : Optional Natural
      , include : List JSON.Type
      , exclude : List JSON.Type
      }

let JSONMap = Map.Type Text JSON.Type

let JSONListsMap = Map.Type Text (List JSON.Type)

let commonToJSONMap
    : CommonType → JSONMap
    = λ(common : CommonType) →
        toMap
          { os = JSON.array (Prelude.List.map OS JSON.Type OS/toJSON common.os)
          , fail-fast =
              merge { None = JSON.null, Some = JSON.bool } common.fail-fast
          , max-parallel =
              merge
                { None = JSON.null, Some = JSON.natural }
                common.max-parallel
          , include = JSON.array common.include
          , exclude = JSON.array common.exclude
          }

let Common =
      { Type = CommonType
      , default =
        { os = [] : List OS
        , fail-fast = None Bool
        , max-parallel = None Natural
        , include = [] : List JSON.Type
        , exclude = [] : List JSON.Type
        }
      , toJSONObject = commonToJSONMap
      }

let mk
    : Common.Type → JSONListsMap → JSON.Type
    = λ(common : Common.Type) →
      λ(other : JSONListsMap) →
        let commonMap = commonToJSONMap common

        let otherMap = Map.map Text (List JSON.Type) JSON.Type JSON.array other

        in  JSON.omitNullFields (JSON.object (otherMap # commonMap))

let _ =
        assert
      :   JSON.renderYAML
            ( mk
                Common::{
                , os = [ OS.macos-latest, OS.ubuntu-latest, OS.`ubuntu-20.04` ]
                , max-parallel = Some 3
                , include =
                  [ JSON.object
                      ( toMap
                          { os = JSON.string "windows-latest"
                          , region = JSON.string "us-gov-east-1"
                          }
                      )
                  , JSON.object
                      ( toMap
                          { potentially-invalid-0 =
                              JSON.string "This is a bit of a free-for-all"
                          , potentially-invalid-1 =
                              JSON.string "I'm not sure yet if that matters"
                          }
                      )
                  ]
                , exclude =
                  [ JSON.object
                      ( toMap
                          { os = JSON.string "ubuntu-20.04"
                          , region = JSON.string "us-west-2"
                          }
                      )
                  , JSON.object
                      ( toMap
                          { potentially-invalid-0 =
                              JSON.string "This is a bit of a free-for-all"
                          , potentially-invalid-1 =
                              JSON.string "I'm not sure yet if that matters"
                          }
                      )
                  ]
                }
                ( toMap
                    { region =
                      [ JSON.string "us-east-1", JSON.string "us-west-2" ]
                    }
                )
            )
        ≡ ''
          "region":
            - "us-east-1"
            - "us-west-2"
          "exclude":
            - "os": "ubuntu-20.04"
              "region": "us-west-2"
            - "potentially-invalid-0": "This is a bit of a free-for-all"
              "potentially-invalid-1": "I'm not sure yet if that matters"
          "include":
            - "os": "windows-latest"
              "region": "us-gov-east-1"
            - "potentially-invalid-0": "This is a bit of a free-for-all"
              "potentially-invalid-1": "I'm not sure yet if that matters"
          "max-parallel": 3
          "os":
            - "macos-latest"
            - "ubuntu-latest"
            - "ubuntu-20.04"
          ''

in  { Common, mk, mkMatrix = mk, otherEmpty = toMap {=} : JSONListsMap }
