{-

TODO: Give this a better name than `fmtInputsDefault2`.

-}
let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/package.dhall

let Inputs = ./Inputs/package.dhall

let mapNone
    : Inputs.Type → Map.Type Text JSON.Type
    = let f = λ(_ : Input.Type) → JSON.null

      in  Map.map Text Input.Type JSON.Type f

let fmtInputsDefault2
    : Inputs.Type → Map.Type Text JSON.Type
    = λ(inputs : Inputs.Type) → mapNone (Inputs.optionalOnly inputs)

let _ = assert : "TODO: write test(s)" ≡ "TODO: write test(s)"

in  fmtInputsDefault2
