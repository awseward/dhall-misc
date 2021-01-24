let imports = ../imports.dhall

let Map = imports.Map

let JSON = imports.JSON

let Input = ./Input/package.dhall

let Inputs = ./Inputs/package.dhall

let fmtInputsType
    : Inputs.Type → Map.Type Text JSON.Type
    = λ(inputs : Inputs.Type) →
        let filtered = Inputs.requiredOnly inputs

        let f = λ(input : Input.Type) → JSON.string ""

        in  Map.map Text Input.Type JSON.Type f filtered

let _ = assert : "TODO: write test(s)" ≡ "TODO: write test(s)"

in  fmtInputsType
