let imports = ../imports.dhall

let Prelude = imports.Prelude

let OS = ./Type.dhall

let show
    : OS → Text
    = λ(os : OS) →
        let ignore = None Text

        in  Prelude.Optional.default
              Text
              (showConstructor os)
              ( merge
                  { `macos-10.15` = ignore
                  , `macos-11.0` = ignore
                  , `ubuntu-16.04` = ignore
                  , `ubuntu-18.04` = ignore
                  , `ubuntu-20.04` = ignore
                  , macos-latest = ignore
                  , other = λ(other : Text) → Some other
                  , ubuntu-latest = ignore
                  , windows-2019 = ignore
                  , windows-latest = ignore
                  }
                  os
              )

let _ = assert : show OS.`ubuntu-20.04` ≡ "ubuntu-20.04"

let _ = assert : show (OS.other "foobar-latest") ≡ "foobar-latest"

in  show
