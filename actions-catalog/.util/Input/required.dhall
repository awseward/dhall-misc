let Input = ./Type.dhall

let isRequired
    : Input → Bool
    = λ(input : Input) →
        merge { None = False, Some = λ(b : Bool) → b } input.required

in  isRequired
