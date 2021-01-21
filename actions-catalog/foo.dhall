let Map = https://prelude.dhall-lang.org/v20.0.0/Map/package.dhall

let JSON = https://prelude.dhall-lang.org/v20.0.0/JSON/package.dhall

let Input = { default : Optional JSON.Type, required : Optional Bool }

in  { inputs : Map.Type Text Input }
