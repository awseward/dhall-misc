let GHA = (../../imports.dhall).GHA

let Inputs =
      https://raw.githubusercontent.com/awseward/gh-actions-shell/0.1.5/inputs.dhall sha256:92ecbb420d99f90ddaf2597144a74afb600f922da2392c18510a2ff554a9b325

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "awseward/gh-actions-shell"
            "0.1.5"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
