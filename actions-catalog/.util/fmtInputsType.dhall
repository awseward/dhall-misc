{-

TODO: Change this so that maybe we can actually get a few `Optional a` instead
      of just all `Optional <>`.

-} -----
let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/Type.dhall

let Inputs = ./Inputs/Type.dhall

let requiredInputsOnly = ./Inputs/requiredOnly.dhall

let excludeRequiredInputs = ./Inputs/optionalOnly.dhall

let fmtInputsType
    : Inputs → Map.Type Text JSON.Type
    = λ(inputs : Inputs) →
        let requiredMap =
              let filtered = requiredInputsOnly inputs

              let f = λ(input : Input) → JSON.string ""

              in  Map.map Text Input JSON.Type f filtered

        let notRequiredMap =
              let filtered = excludeRequiredInputs inputs

              let f = λ(input : Input) → JSON.null

              in  Map.map Text Input JSON.Type f filtered

        in  requiredMap # notRequiredMap

in  fmtInputsType
