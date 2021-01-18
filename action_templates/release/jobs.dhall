let GHA = ../../GHA/package.dhall

let Checkout = ../actions/Checkout.dhall

let nim/Setup = ../nim/Setup.dhall

let OS = GHA.OS.Type

let Step = GHA.Step

let Strategy = GHA.Strategy

let mkRun = Step.mkRun

let subst = GHA.subst

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

let mkJobs =
      λ(opts : Opts.Type) →
        toMap
          { j0-setup = GHA.Job::{
            , runs-on = [ OS.ubuntu-latest ]
            , outputs = toMap
                { git_tag = Step.substOutput "plan" "git_tag"
                , upload_url = Step.substOutput "create-release" "upload_url"
                , html_url = Step.substOutput "create-release" "html_url"
                }
            , steps =
                Checkout.plainDo
                  [ mkRun
                      Step.Common::{
                      , id = Some "plan"
                      , name = Some "Plan release"
                      }
                      ./run/plan.sh as Text
                  , let a = ../actions/CreateRelease.dhall

                    in  a.mkStep
                          a.Common::{
                          , id = Some "create-release"
                          , env = toMap
                              { GITHUB_TOKEN = subst "secrets.GITHUB_TOKEN" }
                          }
                          a.Inputs::{
                          , tag_name = Step.substOutput "plan" "git_tag"
                          , release_name = Step.substOutput "plan" "git_tag"
                          , body = a.Body.text ""
                          , draft = Some False
                          , prerelease = Some False
                          }
                  ]
            }
          , j1-artifacts = GHA.Job::{
            , runs-on = [ OS.other (subst "matrix.os") ]
            , strategy = Some GHA.Strategy::{
              , matrix =
                  Strategy.Matrix.mk
                    Strategy.Matrix.Common::{
                    , os = [ OS.macos-latest, OS.ubuntu-latest ]
                    }
                    Strategy.Matrix.otherEmpty
              }
            , needs = [ "j0-setup" ]
            , steps =
                Checkout.plainDo
                  (   nim/Setup.mkSteps nim/Setup.Opts::{ nimVersion = "1.4.2" }
                    # [ mkRun
                          Step.Common::{
                          , id = Some "tarball"
                          , name = Some "Create tarball"
                          , env = toMap
                              { GIT_TAG =
                                  GHA.Job.substOutput "j0-setup" "git_tag"
                              , PLATFORM_NAME = subst "runner.os"
                              }
                          }
                          ./run/tarball.sh as Text
                      , mkRun
                          Step.Common::{
                          , id = Some "checksum"
                          , name = Some "Record checksum"
                          }
                          ./run/checksum.sh as Text
                      , let a = ../actions/UploadReleaseAsset.dhall

                        in  a.mkStep
                              a.Common::{
                              , id = Some "upload-tarball"
                              , env = toMap
                                  { GITHUB_TOKEN = subst "secrets.GITHUB_TOKEN"
                                  }
                              }
                              a.Inputs::{
                              , asset_content_type = "application/gzip"
                              , asset_name =
                                  Step.substOutput "tarball" "tarball_filename"
                              , asset_path =
                                  Step.substOutput "tarball" "tarball_filepath"
                              , upload_url =
                                  GHA.Job.substOutput "j0-setup" "upload_url"
                              }
                      , let a = ../mislav/BumpHomebrewFormula.dhall

                        in  a.mkStep
                              a.Common::{
                              , `if` = Some (subst "runner.os == 'macOS'")
                              , env = toMap
                                  { COMMITTER_TOKEN =
                                      subst "secrets.COMMITTER_TOKEN"
                                  }
                              }
                              a.Inputs::{
                              , base-branch = Some opts.base-branch
                              , commit-message = Some
                                  ( fmtCommitMsg
                                      "{{formulaName}} {{version}}"
                                      "Sourced from ${GHA.Job.substOutput
                                                        "j0-setup"
                                                        "html_url"}."
                                  )
                              , download-url = Some
                                  ( Step.substOutput
                                      "upload-tarball"
                                      "browser_download_url"
                                  )
                              , formula-name = Some opts.formula-name
                              , homebrew-tap = Some opts.homebrew-tap
                              }
                      ]
                  )
            }
          }

in  { mkJobs, Opts }
