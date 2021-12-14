let Prelude = (../imports.dhall).Prelude

in  { Prelude } ⫽ Prelude.{ List, Map } ⫽ Prelude.List.{ concat }
