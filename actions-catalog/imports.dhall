let Prelude =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.0.0/Prelude/package.dhall sha256:21754b84b493b98682e73f64d9d57b18e1ca36a118b81b33d0a243de8455814b

let JSON/extended =
      let JSON = Prelude.JSON

      let opt =
            λ(a : Type) →
            λ(f : a → JSON.Type) →
            λ(x : Optional a) →
              merge { None = JSON.null, Some = f } x

      in    JSON
          ⫽ { boolOpt = opt Bool JSON.bool
            , doubleOpt = opt Double JSON.double
            , integerOpt = opt Integer JSON.integer
            , naturalOpt = opt Natural JSON.natural
            , numberOpt = opt Double JSON.number
            , opt
            , stringOpt = opt Text JSON.string
            }

let Map/extended =
      let Map = Prelude.Map

      let filter
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

      in  Map ⫽ { filter }

in  { GHA = ../GHA/package.dhall
    , JSON = JSON/extended
    , Map = Map/extended
    , Prelude
    }
