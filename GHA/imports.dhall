let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/package.dhall
        sha256:a6036bc38d883450598d1de7c98ead113196fe2db02e9733855668b18096f07b

let NonEmpty =
      ( https://raw.githubusercontent.com/awseward/dhall-utils/20210612174811/package.dhall
          sha256:a3ab6458723572b061ae5922473c08baca997bcbad7126995e3ebd49dd61f009
      ).NonEmpty

in  { Prelude = Prelude ⫽ { NonEmpty } } ⫽ Prelude.{ Map, Text }
