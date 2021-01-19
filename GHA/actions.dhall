let imports = ./imports.dhall

let Map = imports.Prelude.Map

let JSON = imports.Prelude.JSON

let Step = ./Step.dhall

let mkStep/next =
      λ(a : Type) →
      λ(b : { toJSON : a → Map.Type Text JSON.Type }) →
      λ(name : Text) →
      λ(version : Text) →
      λ(common : Step.Common.Type) →
      λ(inputs : a) →
        Step.mkUses
          common
          Step.Uses::{ uses = "${name}@${version}", `with` = b.toJSON inputs }

let mkStep/legacy =
      λ(name : Text) →
      λ(version : Text) →
      λ(inputType : Type) →
      λ(f : inputType → Map.Type Text JSON.Type) →
      λ(common : Step.Common.Type) →
      λ(inputs : inputType) →
        mkStep/next inputType { toJSON = f } name version

in  { mkStep = mkStep/legacy, mkStep/legacy, mkStep/next }
