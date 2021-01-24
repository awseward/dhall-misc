{-

TODO: Change this so that maybe we can actually get a few `None a` instead of
      just all `None <>`.

-} -----
let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/package.dhall

let Inputs = ./Inputs/package.dhall

let mapNone
    : Inputs.Type → Map.Type Text (Optional JSON.Type)
    = let f = λ(_ : Input.Type) → None JSON.Type

      in  Map.map Text Input.Type (Optional JSON.Type) f

let mapDefaults
    : Inputs.Type → Map.Type Text (Optional JSON.Type)
    = let f = λ(i : Input.Type) → i.default

      in  Map.map Text Input.Type (Optional JSON.Type) f

let fmtInputsDefault
    : Inputs.Type → List (Map.Type Text (Optional JSON.Type))
    = λ(inputs : Inputs.Type) →
        let optionalOnly = Inputs.optionalOnly inputs

        in  [ mapNone optionalOnly ] # [ mapDefaults optionalOnly ]

let _ = assert : "TODO: write test(s)" ≡ "TODO: write test(s)"

in  fmtInputsDefault
