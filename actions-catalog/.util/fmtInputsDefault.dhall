let Map =
      https://prelude.dhall-lang.org/v20.0.0/Map/package.dhall sha256:c6602939eb75ddaf43e75a37e1f27ace97e03685ceb9d77605b4372547f7cfa8

let JSON =
      https://prelude.dhall-lang.org/v20.0.0/JSON/package.dhall sha256:b7dfd33b1a313c0518c637c3b59da8526aa8020dbe125f347edbf895331dbeca

let Input =
      { default : Optional JSON.Type
      , description : Text
      , required : Optional Bool
      }

let renderInput =
      λ(input : Input) →
        let message =
              JSON.string
                ''
                ===================================================================
                NOTE: You probably want to change the type of this to `Optional a`,
                and not provide a default value here of `None a`, where `a` is
                whatever type seems to make sense for this field.
                -------------------------------------------------------------------

                Original Description
                --------------------
                ${input.description}
                ''

        in  merge
              { None = Some message
              , Some =
                  λ(required : Bool) →
                    if required then None JSON.Type else Some message
              }
              input.required

in  Map.map Text Input (Optional JSON.Type) renderInput
