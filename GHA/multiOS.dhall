let OS = ./OS/package.dhall

let Plural = (./imports.dhall).Plural

let Strategy = ./Strategy.dhall

let subst = ./subst.dhall

in  λ(os : Plural.Type OS.Type) →
      { strategy = Some Strategy::{
        , matrix =
            Strategy.Matrix.mk
              Strategy.Matrix.Common::{ os = Plural.toList OS.Type os }
              Strategy.Matrix.otherEmpty
        }
      , runs-on = [ OS.Type.other (subst "matrix.os") ]
      }
