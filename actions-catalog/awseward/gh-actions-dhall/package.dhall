let GHA = (../../imports.dhall).GHA

let Inputs =
      https://raw.githubusercontent.com/awseward/gh-actions-dhall/0.2.9/inputs.dhall sha256:269c18dc4cd467163985d5b9d8630fd8b2e971e6f045b4419689dd1b353ebd68

in    { mkStep =
          GHA.actions.mkStep/next
            Inputs.Type
            Inputs.{ toJSON }
            "awseward/gh-actions-dhall"
            "0.2.9"
      , Inputs
      }
    ⫽ GHA.Step.{ Common }
