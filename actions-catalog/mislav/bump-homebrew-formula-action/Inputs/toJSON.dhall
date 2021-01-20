let imports = ../../../imports.dhall

let Prelude = imports.Prelude

let JSON = Prelude.JSON

let Inputs = ./Type.dhall

in  λ(inputs : Inputs) →
      let j =
            let opt =
                  λ(a : Type) →
                  λ(f : a → JSON.Type) →
                  λ(x : Optional a) →
                    merge { None = JSON.null, Some = f } x

            in  JSON ⫽ { stringOpt = opt Text JSON.string }

      in  toMap
            { base-branch = j.stringOpt inputs.base-branch
            , commit-message = j.stringOpt inputs.commit-message
            , download-url = j.stringOpt inputs.download-url
            , formula-name = j.stringOpt inputs.formula-name
            , homebrew-tap = j.stringOpt inputs.homebrew-tap
            }
