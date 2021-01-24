let imports = ../../imports.dhall

let Map = imports.Map

let Input = ../Input/Type.dhall

let required = ../Input/required.dhall

let Inputs = ./Type.dhall

let optionalOnly
    : Inputs → Inputs
    = let f = λ(i : Input) → if required i then False else True

      in  Map.filter Text Input f

in  optionalOnly
