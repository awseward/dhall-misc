let imports = ../../imports.dhall

let Map = imports.Map

let Input = ../Input/package.dhall

let Inputs/Type = ./Type.dhall

let optionalOnly
    : Inputs/Type → Inputs/Type
    = let compose = imports.Prelude.Function.compose Input.Type Bool Bool

      let f = compose Input.required imports.Prelude.Bool.not

      in  Map.filter Text Input.Type f

in  optionalOnly
