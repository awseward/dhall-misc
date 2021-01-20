let GHA = (../../imports.dhall).GHA

let Inputs =
      https://raw.githubusercontent.com/awseward/gh-actions-dhall/0.2.8/inputs.dhall sha256:c79dac8b41d235a132cce9906fd3d62e00e25ff435de10cf1d486971758442ef

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "awseward/gh-actions-dhall"
            "0.2.8"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
