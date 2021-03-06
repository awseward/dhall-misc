let GHA = ../../GHA/package.dhall

let Checkout = ../actions/Checkout.dhall

let nim/Setup = ../nim/Setup.dhall

let OS = GHA.OS.Type

let Step = GHA.Step

let Strategy = GHA.Strategy

let mkRun = Step.mkRun

let subst = GHA.subst

let Opts
         -- This might not be ideal but it'll work for now…
         =
      let Opts = ./Opts.dhall

      let Type_ = Opts.Type ⩓ { nimVersion : Text }

      let default_ = Opts.default ⫽ { nimVersion = "1.4.2" }

      in  { Type = Type_, default = default_ }

let fmtCommitMsg = ./fmtCommitMsg.dhall

let mkJobs =
      λ(opts : Opts.Type) →
        let outs =
              { create-release = Step.substOutput "create-release"
              , setup = GHA.Job.substOutput "setup"
              , plan = Step.substOutput "plan"
              , tarball = Step.substOutput "tarball"
              , upload-tarball = Step.substOutput "upload-tarball"
              }

        in  toMap
              { setup =
                  --
                  -- Takes care of some upfront clerical things:
                  --
                  -- 1. Resolving the git tag to name the release for
                  -- 2. Creating an actual `Release` record on GitHub
                  --
                  GHA.Job::{
                  , runs-on = [ OS.ubuntu-latest ]
                  , outputs = toMap
                      { git_tag = outs.plan "git_tag"
                      , upload_url = outs.create-release "upload_url"
                      , html_url = outs.create-release "html_url"
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
                                    { GITHUB_TOKEN =
                                        subst "secrets.GITHUB_TOKEN"
                                    }
                                }
                                a.Inputs::{
                                , tag_name = outs.plan "git_tag"
                                , release_name = outs.plan "git_tag"
                                , body = a.Inputs.Body.text ""
                                , draft = Some False
                                , prerelease = Some False
                                }
                        ]
                  }
              , artifacts =
                  --
                  -- Creates actual release assets, uploads them to the
                  -- `Release` created by `setup`, and submits a pull request
                  -- to the appropriate Homebrew tap if applicable
                  --
                  GHA.Job::{
                  , runs-on = [ OS.other (subst "matrix.os") ]
                  , strategy = Some GHA.Strategy::{
                    , matrix =
                        Strategy.Matrix.mk
                          Strategy.Matrix.Common::{
                          , os = [ OS.macos-latest, OS.ubuntu-latest ]
                          }
                          Strategy.Matrix.otherEmpty
                    }
                  , needs = [ "setup" ]
                  , steps =
                      Checkout.plainDo
                        (   nim/Setup.mkSteps
                              nim/Setup.Opts::opts.{ nimVersion }
                          # [ mkRun
                                Step.Common::{
                                , id = Some "tarball"
                                , name = Some "Create tarball"
                                , env = toMap
                                    { GIT_TAG = outs.setup "git_tag"
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
                                        { GITHUB_TOKEN =
                                            subst "secrets.GITHUB_TOKEN"
                                        }
                                    }
                                    a.Inputs::{
                                    , asset_content_type = "application/gzip"
                                    , asset_name =
                                        outs.tarball "tarball_filename"
                                    , asset_path =
                                        outs.tarball "tarball_filepath"
                                    , upload_url = outs.setup "upload_url"
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
                                            "Sourced from ${outs.setup
                                                              "html_url"}."
                                        )
                                    , download-url = Some
                                        ( outs.upload-tarball
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
