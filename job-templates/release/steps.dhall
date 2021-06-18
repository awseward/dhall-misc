let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let mkRun = Step.mkRun

let Opts =
      { Type = { formula-name : Text, homebrew-tap : Text, base-branch : Text }
      , default.base-branch = "main"
      }

let fmtCommitMsg =
      λ(header : Text) →
      λ(body : Text) →
        ''
        ${header}

        ${body}
        ''

let subst = GHA.subst

let mkSteps =
      λ(opts : Opts.Type) →
        let outs =
              { checksum = Step.substOutput "checksum"
              , create-release = Step.substOutput "create-release"
              , plan = Step.substOutput "plan"
              , tarball = Step.substOutput "tarball"
              , upload-tarball = Step.substOutput "upload-tarball"
              }

        in  [ mkRun
                Step.Common::{ id = Some "plan", name = Some "Plan release" }
                ./run/plan.sh as Text
            , mkRun
                Step.Common::{
                , id = Some "tarball"
                , name = Some "Create tarball"
                }
                ./run/tarball.sh as Text
            , mkRun
                Step.Common::{
                , id = Some "checksum"
                , name = Some "Record checksum"
                }
                ./run/checksum.sh as Text
            , let a = ../actions/CreateRelease.dhall

              in  a.mkStep
                    a.Common::{
                    , id = Some "create-release"
                    , env = toMap
                        { GITHUB_TOKEN = subst "secrets.GITHUB_TOKEN" }
                    }
                    a.Inputs::{
                    , tag_name = outs.plan "git_tag"
                    , release_name = outs.plan "git_tag"
                    , body =
                        a.Inputs.Body.text
                          "Checksum: `${outs.checksum "tarball_checksum"}`"
                    , draft = Some False
                    , prerelease = Some False
                    }
            , let a = ../actions/UploadReleaseAsset.dhall

              in  a.mkStep
                    a.Common::{
                    , id = Some "upload-tarball"
                    , env = toMap
                        { GITHUB_TOKEN = subst "secrets.GITHUB_TOKEN" }
                    }
                    a.Inputs::{
                    , asset_content_type = "application/gzip"
                    , asset_name = outs.tarball "tarball_filename"
                    , asset_path = outs.tarball "tarball_filepath"
                    , upload_url = outs.create-release "upload_url"
                    }
            , let a = ../mislav/BumpHomebrewFormula.dhall

              in  a.mkStep
                    a.Common::{
                    , env = toMap
                        { COMMITTER_TOKEN = subst "secrets.COMMITTER_TOKEN" }
                    }
                    a.Inputs::{
                    , base-branch = Some opts.base-branch
                    , commit-message = Some
                        ( fmtCommitMsg
                            "{{formulaName}} {{version}}"
                            "Sourced from ${outs.create-release "html_url"}."
                        )
                    , download-url = Some
                        (outs.upload-tarball "browser_download_url")
                    , formula-name = Some opts.formula-name
                    , homebrew-tap = Some opts.homebrew-tap
                    }
            ]

in  { mkSteps, Opts }
