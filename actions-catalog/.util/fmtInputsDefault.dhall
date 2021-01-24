{-

TODO: Change this so that maybe we can actually get a few `None a` instead of
      just all `None <>`.

-} -----
let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/package.dhall

let Inputs = ./Inputs/package.dhall

let allNull
    : Inputs.Type → Map.Type Text JSON.Type
    = Map.map Text Input.Type JSON.Type (λ(_ : Input.Type) → JSON.null)

in  λ(inputs : Inputs.Type) → allNull (Inputs.optionalOnly inputs)
