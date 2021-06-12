let Strategy = ./Strategy.dhall

let OS = ./OS/package.dhall

let subst = ./subst.dhall

in  λ(head : OS.Type) →
    λ(tail : List OS.Type) →
      { strategy = Some Strategy::{
        , matrix =
            Strategy.Matrix.mk
              Strategy.Matrix.Common::{ os = OS.toList (OS.make head tail) }
              Strategy.Matrix.otherEmpty
        }
      , runs-on = [ OS.Type.other (subst "matrix.os") ]
      }
