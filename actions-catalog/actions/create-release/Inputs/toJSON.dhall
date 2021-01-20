let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Map = Prelude.Map

let Inputs = ./Type.dhall

let Body = ./Body.dhall

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
                    , stringOpt = opt Text JSON.string
                    }

        let Body/toJSON =
              λ(body : Body) →
                merge
                  { text =
                      λ(body : Text) →
                        { body = j.string body, body_path = j.null }
                  , path =
                      λ(path : Text) →
                        { body = j.null, body_path = j.string path }
                  }
                  body

        in  toMap
              (   Body/toJSON inputs.body
                ⫽ { tag_name = j.string inputs.tag_name
                  , release_name = j.string inputs.tag_name
                  , draft = j.boolOpt inputs.draft
                  , prerelease = j.boolOpt inputs.prerelease
                  , commitish = j.stringOpt inputs.commitish
                  , owner = j.stringOpt inputs.owner
                  , repo = j.stringOpt inputs.repo
                  }
              )

in  toJSON
