let imports = ../../imports.dhall

let Map = imports.Map

let Input = ../Input/package.dhall

let Inputs/Type = ./Type.dhall

let optionalOnly
    : Inputs/Type → Inputs/Type
    = let f = λ(i : Input.Type) → if Input.required i then False else True

      in  Map.filter Text Input.Type f

in  optionalOnly
