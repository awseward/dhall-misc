let Map = https://prelude.dhall-lang.org/v20.0.0/Map/package.dhall

let JSON = https://prelude.dhall-lang.org/v20.0.0/JSON/package.dhall

let Input =
      { default : Optional JSON.Type
      , description : Text
      , required : Optional Bool
      }

let Inputs = Map.Type Text Input

in  Map.map Text Input Text (λ(_ : Input) → "")
