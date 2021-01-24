let Input/Type = ./Type.dhall

let isRequired
    : Input/Type → Bool
    = λ(input : Input/Type) →
        merge { None = False, Some = λ(b : Bool) → b } input.required

in  isRequired
