let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let GHA = ../../GHA/package.dhall

let name = "actions/create-release"

let version = "v1"

let Body = < text : Text | path : Text >

let Inputs =
      let T =
            { tag_name : Text
            , release_name : Text
            , body : Body
            , draft : Optional Bool
            , prerelease : Optional Bool
            , commitish : Optional Text
            , owner : Optional Text
            , repo : Optional Text
            }

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

      let jBody =
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

      in  { Type = T
          , default =
            { draft = None Bool
            , prerelease = None Bool
            , commitish = None Text
            , owner = None Text
            , repo = None Text
            }
          , toJSON =
              λ(inputs : T) →
                toMap
                  (   jBody inputs.body
                    ⫽ { tag_name = j.string inputs.tag_name
                      , release_name = j.string inputs.tag_name
                      , draft = j.boolOpt inputs.draft
                      , prerelease = j.boolOpt inputs.prerelease
                      , commitish = j.stringOpt inputs.commitish
                      , owner = j.stringOpt inputs.owner
                      , repo = j.stringOpt inputs.repo
                      }
                  )
          }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

let _ =
        assert
      : let step =
              mkStep
                GHA.Step.Common::{=}
                Inputs::{
                , body = Body.text "foo"
                , tag_name = "bar"
                , release_name = "qux"
                , prerelease = Some False
                , draft = Some True
                }

        let `with` = JSON.omitNullFields (JSON.object step.`with`)

        in    assert
            :   JSON.renderYAML `with`
              ≡ ''
                "body": "foo"
                "draft": true
                "prerelease": false
                "release_name": "bar"
                "tag_name": "bar"
                ''

in  { mkStep, Inputs, Body } ⫽ GHA.Step.{ Common }
