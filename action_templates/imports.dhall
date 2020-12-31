let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/List/package.dhall sha256:547cd881988c6c5e3673ae80491224158e93a4627690db0196cb5efbbf00d2ba

in  { List = List/pkg
    , Map =
        https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/Map/package.dhall sha256:c6602939eb75ddaf43e75a37e1f27ace97e03685ceb9d77605b4372547f7cfa8
    , concat = List/pkg.concat
    }
