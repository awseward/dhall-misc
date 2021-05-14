let pkg = ../../actions-catalog/actions/create-release/package.dhall

let GHA = ../../GHA/package.dhall

let JSON = (../imports.dhall).Prelude.JSON

let _ =
      let step =
            pkg.mkStep
              GHA.Step.Common::{=}
              pkg.Inputs::{
              , body = pkg.Inputs.Body.text "foo"
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

in  pkg
