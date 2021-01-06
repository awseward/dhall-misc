let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let mkRun = Step.mkRun

let Opts =
      { Type = { formula-name : Text, homebrew-tap : Text, base-branch : Text }
      , default.base-branch = "master"
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
        [ mkRun
            Step.Common::{ id = Some "plan", name = Some "Plan release" }
            ./run/plan.sh as Text
        , mkRun
            Step.Common::{ id = Some "tarball", name = Some "Create tarball" }
            ./run/tarball.sh as Text
        , mkRun
            Step.Common::{ id = Some "checksum", name = Some "Record checksum" }
            ./run/checksum.sh as Text
        , let a = ../actions/CreateRelease.dhall

          in  a.mkStep
                a.Common::{
                , id = Some "create_release"
                , env = toMap { GITHUB_TOKEN = subst "secrets.GITHUB_TOKEN" }
                }
                a.Inputs::{
                , tag_name = subst "steps.plan.outputs.git_tag"
                , release_name = subst "steps.plan.outputs.git_tag"
                , body = Some
                    "Checksum: `${subst
                                    "steps.checksum.outputs.tarball_checksum"}`"
                , draft = Some False
                , prerelease = Some False
                }
        , let a = ../actions/UploadReleaseAsset.dhall

          in  a.mkStep
                a.Common::{
                , id = Some "upload_tarball"
                , env = toMap { GITHUB_TOKEN = subst "secrets.GITHUB_TOKEN" }
                }
                a.Inputs::{
                , asset_content_type = "application/gzip"
                , asset_name = subst "steps.tarball.outputs.tarball_filename"
                , asset_path = subst "steps.tarball.outputs.tarball_filepath"
                , upload_url = subst "steps.create_release.outputs.upload_url"
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
                        "Sourced from ${subst
                                          "steps.create_release.outputs.html_url"}."
                    )
                , download-url = Some
                    (subst "steps.upload_tarball.outputs.browser_download_url")
                , formula-name = Some opts.formula-name
                , homebrew-tap = Some opts.homebrew-tap
                }
        ]

in  { mkSteps, Opts }
