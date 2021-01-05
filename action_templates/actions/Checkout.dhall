let imports = ../imports.dhall

let Prelude = imports.Prelude

let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let name = "actions/checkout"

let version = "v2"

let Inputs =
      { Type =
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
      }

let boolMapShow =
      Prelude.Optional.map
        Bool
        Text
        ( λ(bool : Bool) →
            Text/replace "T" "t" (Text/replace "F" "f" (Prelude.Bool.show bool))
        )

let _ = assert : boolMapShow (None Bool) ≡ None Text

let _ = assert : boolMapShow (Some True) ≡ Some "true"

let _ = assert : boolMapShow (Some False) ≡ Some "false"

let naturalMapShow = Prelude.Optional.map Natural Text Natural/show

let _ = assert : naturalMapShow (None Natural) ≡ None Text

let _ = assert : naturalMapShow (Some 5) ≡ Some "5"

let inputsToMap =
      λ(inputs : Inputs.Type) →
        let homogenized =
                inputs
              ⫽ { ssh-strict = boolMapShow inputs.ssh-strict
                , persist-credentials = boolMapShow inputs.persist-credentials
                , clean = boolMapShow inputs.clean
                , fetch-depth = naturalMapShow inputs.fetch-depth
                , lfs = boolMapShow inputs.lfs
                , submodules = boolMapShow inputs.submodules
                }

        in  Prelude.Map.unpackOptionals Text Text (toMap homogenized)

let mkStep =
      GHA.actions.mkStep
        name
        version
        Inputs.Type
        (λ(inputs : Inputs.Type) → inputsToMap inputs)

let concatStep = imports.concat Step.Type

let do =
      λ(checkout : Step.Type) →
      λ(subsequent : List (List Step.Type)) →
        concatStep [ [ checkout ], concatStep subsequent ]

let plain = mkStep Step.Common::{=} Inputs::{=}

let plainDo = do plain

in  { do, plain, plainDo, mkStep, Inputs } ⫽ GHA.Step.{ Common }
