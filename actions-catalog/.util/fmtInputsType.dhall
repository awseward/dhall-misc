{-

TODO: Change this so that maybe we can actually get a few `Optional a` instead
      of just all `Optional <>`.

-} -----
let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/package.dhall

let Inputs = ./Inputs/package.dhall

let fmtInputsType
    : Inputs.Type → Map.Type Text JSON.Type
    = λ(inputs : Inputs.Type) →
        let requiredMap =
              let filtered = Inputs.requiredOnly inputs

              let f = λ(input : Input.Type) → JSON.string ""

              in  Map.map Text Input.Type JSON.Type f filtered

        let notRequiredMap =
              let filtered = Inputs.optionalOnly inputs

              let f = λ(input : Input.Type) → JSON.null

              in  Map.map Text Input.Type JSON.Type f filtered

        in  requiredMap # notRequiredMap

in  fmtInputsType
