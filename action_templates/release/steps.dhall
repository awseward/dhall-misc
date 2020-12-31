let GHA = ./gha/jobs.dhall

let run = GHA.Step.run

let use = GHA.Step.use

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
        [ run
            GHA.Run::{
            , id = Some "plan"
            , name = Some "Plan release"
            , run = ./release/plan.sh as Text
            }
        , run
            GHA.Run::{
            , id = Some "tarball"
            , name = Some "Create tarball"
            , run = ./release/tarball.sh as Text
            }
        , run
            GHA.Run::{
            , id = Some "checksum"
            , name = Some "Record checksum"
            , run = ./release/checksum.sh as Text
            }
        , uses
            GHA.Uses::{
            , id = Some "create_release"
            , uses = "actions/create-release@v1"
            , env = toMap { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }
            , `with` = toMap
                { tag_name = "\${{ steps.plan.outputs.git_tag }}"
                , release_name = "\${{ steps.plan.outputs.git_tag }}"
                , body =
                    "Checksum: `\${{ steps.checksum.outputs.tarball_checksum }}`"
                , draft = "false"
                , prerelease = "false"
                }
            }
        , uses
            GHA.Uses::{
            , id = Some "upload_tarball"
            , uses = "actions/upload-release-asset@v1"
            , env = toMap { GITHUB_TOKEN = "\${{ secrets.GITHUB_TOKEN }}" }
            , `with` = toMap
                { asset_content_type = "application/gzip"
                , asset_name = "\${{ steps.tarball.outputs.tarball_filename }}"
                , asset_path = "\${{ steps.tarball.outputs.tarball_filepath }}"
                , upload_url = "\${{ steps.create_release.outputs.upload_url }}"
                }
            }
        , uses
            GHA.Uses::{
            , uses = "mislav/bump-homebrew-formula-action@v1.6"
            , env = toMap
                { COMMITTER_TOKEN = "\${{ secrets.COMMITTER_TOKEN }}" }
            , `with` =
                  toMap
                    { download-url =
                        "\${{ steps.upload_tarball.outputs.browser_download_url }}"
                    , commit-message =
                        fmtCommitMsg
                          "{{formulaName}} {{version}}"
                          "Sourced from \${{ steps.create_release.outputs.html_url }}."
                    }
                ⫽ opts
            }
        ]
          GHA.Step

in  { mkSteps }
