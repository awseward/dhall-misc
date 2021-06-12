let _Type = ./Type.dhall

let NonEmpty = (../imports.dhall).Prelude.NonEmpty

in  { make = NonEmpty.make _Type
    , singleton = NonEmpty.singleton _Type
    , toList = NonEmpty.toList _Type
    }
