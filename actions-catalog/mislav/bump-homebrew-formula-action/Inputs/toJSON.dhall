let imports = ../../../imports.dhall

let JSON = imports.JSON

let Inputs = ./Type.dhall

in  λ(inputs : Inputs) →
      let j = JSON

      in  toMap
            { base-branch = j.stringOpt inputs.base-branch
            , commit-message = j.stringOpt inputs.commit-message
            , download-url = j.stringOpt inputs.download-url
            , formula-name = j.stringOpt inputs.formula-name
            , homebrew-tap = j.stringOpt inputs.homebrew-tap
            }
