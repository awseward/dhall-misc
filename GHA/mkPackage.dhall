let imports = ./imports.dhall

let Map = imports.Prelude.Map

let Step = ./Step.dhall

let actions = ./actions.dhall

let Serde
          -- This is probably a somewhat dubious use of the term `serde`, but
          -- on the other hand, I haven't been able to come up with much I like
          -- a whole lot better…
          =
      λ(a : Type) → { toJSON : a → Map.Type Text imports.Prelude.JSON.Type }

in  λ(Inputs : Type) →
    λ(serde : Serde Inputs) →
    λ(id : Text) →
    λ(version : Text) →
      let mkStep/next = actions.mkStep/next Inputs serde

      let mkStep = mkStep/next id version

      in  { mkStep, mkStep/next } ⫽ Step.{ Common }
