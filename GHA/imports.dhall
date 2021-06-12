let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/package.dhall
        sha256:a6036bc38d883450598d1de7c98ead113196fe2db02e9733855668b18096f07b

let dhall-utils =
      https://raw.githubusercontent.com/awseward/dhall-utils/20210612223556/package.dhall
        sha256:86e54888676e53ed156742ab15653806ea8d6f39daca47abd395323717c04ec0

in  { Map = Prelude.Map
    , Plural = dhall-utils.Plural
    , Prelude = Prelude ⫽ dhall-utils.{ NonEmpty }
    , Text = Prelude.Text
    }
