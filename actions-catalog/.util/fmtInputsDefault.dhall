{-

TODO: Change this so that maybe we can actually get a few `None a` instead of
      just all `None <>`.

-} -----
let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/Type.dhall

let Inputs = ./Inputs/Type.dhall

let optionalOnly = ./Inputs/optionalOnly.dhall

let allNull
    : Inputs → Map.Type Text JSON.Type
    = Map.map Text Input JSON.Type (λ(_ : Input) → JSON.null)

in  λ(inputs : Inputs) → allNull (optionalOnly inputs)
