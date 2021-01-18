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
                let bodyOrBodyPath =
                      merge
                        { text =
                            λ(body : Text) →
                              { body = JSON.string body, body_path = JSON.null }
                        , path =
                            λ(path : Text) →
                              { body = JSON.null, body_path = JSON.string path }
                        }
                        inputs.body

                in  toMap
                      (   bodyOrBodyPath
                        ⫽ { tag_name = JSON.string inputs.tag_name
                          , release_name = JSON.string inputs.tag_name
                          , draft =
                              merge
                                { None = JSON.null, Some = JSON.bool }
                                inputs.draft
                          , prerelease =
                              merge
                                { None = JSON.null, Some = JSON.bool }
                                inputs.prerelease
                          , commitish =
                              merge
                                { None = JSON.null, Some = JSON.string }
                                inputs.commitish
                          , owner =
                              merge
                                { None = JSON.null, Some = JSON.string }
                                inputs.owner
                          , repo =
                              merge
                                { None = JSON.null, Some = JSON.string }
                                inputs.repo
                          }
                      )
          }

let mkStep = GHA.actions.mkStep name version Inputs.Type Inputs.toJSON

in  { mkStep, Inputs, Body } ⫽ GHA.Step.{ Common }
