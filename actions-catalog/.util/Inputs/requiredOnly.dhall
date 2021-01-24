let imports = ../../imports.dhall

let Map = imports.Map

let Input = ../Input/Type.dhall

let required = ../Input/required.dhall

let Inputs = ./Type.dhall

let requiredOnly
    : Inputs → Inputs
    = Map.filter Text Input required

in  requiredOnly
