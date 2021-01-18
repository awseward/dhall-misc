let imports = ./imports.dhall

let Map = imports.Prelude.Map

let JSON = imports.Prelude.JSON

let Step = ./Step.dhall

in  { mkStep =
        λ(name : Text) →
        λ(version : Text) →
        λ(inputType : Type) →
        λ(f : inputType → Map.Type Text JSON.Type) →
        λ(common : Step.Common.Type) →
        λ(inputs : inputType) →
          Step.mkUses
            common
            Step.Uses::{ uses = "${name}@${version}", `with` = f inputs }
    }
