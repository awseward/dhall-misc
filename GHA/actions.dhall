let imports =
      { GHA =
          https://raw.githubusercontent.com/awseward/dhall-misc/5cd89bd529926b2e06e04731c87c02e07b3423b8/GHA/package.dhall sha256:c646e22542997a419218871938b9c902aeb9ed134116ad0e5ca06bd119d2c663
      , Map =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/Map/package.dhall sha256:c6602939eb75ddaf43e75a37e1f27ace97e03685ceb9d77605b4372547f7cfa8
      }

let Map = imports.Map

let GHA = imports.GHA

in  { mkStep =
        λ(name : Text) →
        λ(version : Text) →
        λ(inputType : Type) →
        λ(f : inputType → Map.Type Text Text) →
        λ(common : GHA.Step.Common.Type) →
        λ(inputs : inputType) →
          GHA.Step.mkUses
            common
            GHA.Step.Uses::{ uses = "${name}@${version}", `with` = f inputs }
    }