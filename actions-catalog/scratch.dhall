let Map = https://prelude.dhall-lang.org/v20.0.0/Map/package.dhall

let JSON =
      let JSON = https://prelude.dhall-lang.org/v20.0.0/JSON/package.dhall

      in    JSON
          ⫽ { renderOpt =
                λ(jOpt : Optional JSON.Type) →
                  merge
                    { None = Some "__FIXME__"
                    , Some = λ(j : JSON.Type) → Some (JSON.render j)
                    }
                    jOpt
            }

let Input = { default : Optional JSON.Type, required : Optional Bool }

let renderInput =
      λ(input : Input) →
        merge
          { None = JSON.renderOpt input.default
          , Some = λ(_ : Bool) → JSON.renderOpt input.default
          }
          input.required

in  Map.map Text Input (Optional Text) renderInput (./parsed.dhall).inputs
