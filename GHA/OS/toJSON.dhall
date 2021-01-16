let imports = ../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let OS = ./Type.dhall

let show = ./show.dhall

let toJSON
    : OS → JSON.Type
    = Prelude.Function.compose OS Text JSON.Type show JSON.string

let _ = assert : toJSON OS.windows-2019 ≡ JSON.string "windows-2019"

let _ = assert : toJSON (OS.other "qux-20210118") ≡ JSON.string "qux-20210118"

in  toJSON
