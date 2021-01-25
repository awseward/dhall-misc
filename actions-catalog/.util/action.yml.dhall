let Map =
      https://prelude.dhall-lang.org/v20.0.0/Map/package.dhall sha256:c6602939eb75ddaf43e75a37e1f27ace97e03685ceb9d77605b4372547f7cfa8

let JSON =
      https://prelude.dhall-lang.org/v20.0.0/JSON/package.dhall sha256:b7dfd33b1a313c0518c637c3b59da8526aa8020dbe125f347edbf895331dbeca

let Input = { default : Optional JSON.Type, required : Optional Bool }

in  { inputs : Map.Type Text Input }
