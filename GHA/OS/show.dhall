let imports = ../imports.dhall

let Prelude = imports.Prelude

let OS = ./Type.dhall

let show
    : OS → Text
    = λ(os : OS) →
        merge
          { `macos-10.15` = "macos-10.15"
          , `macos-11.0` = "macos-11.0"
          , `ubuntu-16.04` = "ubuntu-16.04"
          , `ubuntu-18.04` = "ubuntu-18.04"
          , `ubuntu-20.04` = "ubuntu-20.04"
          , macos-latest = "macos-latest"
          , other = Prelude.Function.identity Text
          , ubuntu-latest = "ubuntu-latest"
          , windows-2019 = "windows-2019"
          , windows-latest = "windows-latest"
          }
          os

let _ = assert : show OS.`ubuntu-20.04` ≡ "ubuntu-20.04"

let _ = assert : show (OS.other "foobar-latest") ≡ "foobar-latest"

in  show
