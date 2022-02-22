let Prelude = (../imports.dhall).Prelude

let KOptV = Prelude.Map.Entry Text (Optional Text)

let KV = Prelude.Map.Entry Text Text

let KOptV/tryGet =
      λ(kOv : KOptV) →
        merge
          { Some = λ(val : Text) → Some { mapKey = kOv.mapKey, mapValue = val }
          , None = None KV
          }
          kOv.mapValue

let KV/concatSep =
      λ(sep : Text) →
      λ(kv : KV) →
        Prelude.Text.concatSep "=" [ kv.mapKey, kv.mapValue ]

let asLines = Prelude.Text.concatSep "\n"

let render =
      λ(entries : List KV) →
        asLines (Prelude.List.map KV Text (KV/concatSep "=") entries)

let tryShow =
      λ(map : List KOptV) →
        let entries = Prelude.List.filterMap KOptV KV KOptV/tryGet map

        in  if    Prelude.List.null KV entries
            then  None Text
            else  Some (render entries)

let show = λ(map : List KOptV) → Prelude.Optional.default Text "" (tryShow map)

let _example0 =
      let _ =
              assert
            :   KOptV/tryGet { mapKey = "foo", mapValue = Some "this_is_foo" }
              ≡ Some { mapKey = "foo", mapValue = "this_is_foo" }

      let _ =
              assert
            : KOptV/tryGet { mapKey = "bar", mapValue = None Text } ≡ None KV

      in  <>

let _example =
      let map =
            toMap
              { FOO = Some "this_is_foo"
              , bar = None Text
              , HELLO = Some "world"
              }

      let expected =
            ''
            FOO=this_is_foo
            HELLO=world''

      let _ = assert : tryShow map ≡ Some expected

      let _ = assert : show map ≡ expected

      in  <>

in  { tryShow }
