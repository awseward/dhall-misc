let Map =
      https://prelude.dhall-lang.org/v20.0.0/Map/package.dhall sha256:c6602939eb75ddaf43e75a37e1f27ace97e03685ceb9d77605b4372547f7cfa8

let JSON =
      https://prelude.dhall-lang.org/v20.0.0/JSON/package.dhall sha256:b7dfd33b1a313c0518c637c3b59da8526aa8020dbe125f347edbf895331dbeca

let Map/filter
    : ∀(k : Type) → ∀(a : Type) → (a → Bool) → Map.Type k a → Map.Type k a
    = λ(k : Type) →
      λ(a : Type) →
      λ(f : a → Bool) →
      λ(map : Map.Type k a) →
        Map.unpackOptionals
          k
          a
          ( Map.map
              k
              a
              (Optional a)
              (λ(x : a) → if f x then Some x else None a)
              map
          )

let Input =
      { default : Optional JSON.Type
      , description : Text
      , required : Optional Bool
      }

let isRequired
    : Input → Bool
    = λ(input : Input) →
        merge { None = False, Some = λ(b : Bool) → b } input.required

let Inputs = Map.Type Text Input

let excludeRequiredInputs
    : Inputs → Inputs
    = let f = λ(i : Input) → if isRequired i then False else True

      in  Map/filter Text Input f

let allNull
    : Inputs → Map.Type Text JSON.Type
    = Map.map Text Input JSON.Type (λ(_ : Input) → JSON.null)

in  λ(inputs : Inputs) → allNull (excludeRequiredInputs inputs)
