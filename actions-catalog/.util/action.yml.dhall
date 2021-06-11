let Map =
      https://prelude.dhall-lang.org/v20.2.0/Map/package.dhall
        sha256:c6602939eb75ddaf43e75a37e1f27ace97e03685ceb9d77605b4372547f7cfa8

let JSON =
      https://prelude.dhall-lang.org/v20.2.0/JSON/package.dhall
        sha256:5f98b7722fd13509ef448b075e02b9ff98312ae7a406cf53ed25012dbc9990ac

let Input = { default : Optional JSON.Type, required : Optional Bool }

in  { inputs : Map.Type Text Input }
