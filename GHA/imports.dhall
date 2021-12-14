let imports = ../imports.dhall

let Prelude = imports.Prelude

let dhall-utils = imports.dhall-utils

in  { Map = Prelude.Map
    , Plural = dhall-utils.Plural
    , Prelude = Prelude ⫽ dhall-utils.{ NonEmpty }
    , Text = Prelude.Text
    }
