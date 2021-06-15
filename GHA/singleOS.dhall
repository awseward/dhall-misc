let OS = ./OS/package.dhall

let Strategy = ./Strategy.dhall

in  λ(os : OS.Type) → { runs-on = [ os ], strategy = None Strategy.Type }
