let GHA = (../../imports.dhall).GHA

let Inputs =
      https://raw.githubusercontent.com/awseward/gh-actions-dhall/0.3.2/inputs.dhall
        sha256:8947aa7b7f16079709e99d780b53d3d12658ffadb1dacc4f9c7a2a8ea7054ba8

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "awseward/gh-actions-dhall"
            "0.3.2"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
