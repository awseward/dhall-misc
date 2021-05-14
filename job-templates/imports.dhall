let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/package.dhall sha256:21754b84b493b98682e73f64d9d57b18e1ca36a118b81b33d0a243de8455814b

in  { Prelude } ⫽ Prelude.{ List, Map } ⫽ Prelude.List.{ concat }
