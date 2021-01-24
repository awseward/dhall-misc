let imports = ../../imports.dhall

let Map = imports.Map

let Input = ../Input/package.dhall

let Inputs/Type = ./Type.dhall

let requiredOnly
    : Inputs/Type → Inputs/Type
    = Map.filter Text Input.Type Input.required

in  requiredOnly
