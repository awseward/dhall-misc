let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let mkRun = Step.mkRun

let mkUses = Step.mkUses

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
        , mkUses
            Step.Common::{
            , id = Some "create_release"
            , env = toMap { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }
            }
            Step.Uses::{
            , uses = "actions/create-release@v1"
            , `with` = toMap
                { tag_name = "\${{ steps.plan.outputs.git_tag }}"
                , release_name = "\${{ steps.plan.outputs.git_tag }}"
                , body =
                    "Checksum: `\${{ steps.checksum.outputs.tarball_checksum }}`"
                , draft = "false"
                , prerelease = "false"
                }
            }
        , mkUses
            Step.Common::{
            , id = Some "upload_tarball"
            , env = toMap { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }
            }
            Step.Uses::{
            , uses = "actions/upload-release-asset@v1"
            , `with` = toMap
                { asset_content_type = "application/gzip"
                , asset_name = "\${{ steps.tarball.outputs.tarball_filename }}"
                , asset_path = "\${{ steps.tarball.outputs.tarball_filepath }}"
                , upload_url = "\${{ steps.create_release.outputs.upload_url }}"
                }
            }
        , mkUses
            Step.Common::{
            , env = toMap
                { COMMITTER_TOKEN = "\${{ secrets.COMMITTER_TOKEN }}" }
            }
            Step.Uses::{
            , uses = "mislav/bump-homebrew-formula-action@v1.6"
            , `with` = toMap
                (   { download-url =
                        "\${{ steps.upload_tarball.outputs.browser_download_url }}"
                    , commit-message =
                        fmtCommitMsg
                          "{{formulaName}} {{version}}"
                          "Sourced from \${{ steps.create_release.outputs.html_url }}."
                    }
                  ⫽ opts
                )
            }
        ]

in  { mkSteps, Opts }
