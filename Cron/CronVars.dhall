let Prelude = (../imports.dhall).Prelude

let List/filter = Prelude.List.filter

let List/map = Prelude.List.map

let List/null = Prelude.List.null

let Map/Entry = Prelude.Map.entry

let Map/map = Prelude.Map.map

let Optional/some =
      let Optional/any = Prelude.Optional.any

      in  λ(t : Type) → λ(a : Optional t) → Optional/any t (λ(_ : t) → True) a

let Optional/default = Prelude.Optional.default

let Text/concatSep = Prelude.Text.concatSep

let KOptV = Map/Entry Text (Optional Text)

let KV = Map/Entry Text Text

let tryShow =
      λ(map : List KOptV) →
        let filtered =
              List/filter
                KOptV
                (λ(kOv : KOptV) → Optional/some Text kOv.mapValue)
                map

        let someValKVs =
              Map/map
                Text
                (Optional Text)
                Text
                (Optional/default Text "")
                filtered

        in  if    List/null KV someValKVs
            then  None Text
            else  let sep = "\n"

                  in  Some
                        ( Text/concatSep
                            sep
                            ( List/map
                                KV
                                Text
                                ( λ(kv : KV) →
                                    Text/concatSep
                                      "="
                                      [ kv.mapKey, kv.mapValue ]
                                )
                                someValKVs
                            )
                        )

let show = λ(map : List KOptV) → Optional/default Text "" (tryShow map)

let _example =
      let map = toMap { FOO = Some "this_is_foo", bar = None Text }

      let expected = "FOO=this_is_foo"

      let _ = assert : tryShow map ≡ Some expected

      let _ = assert : show map ≡ expected

      in  {}

in  { tryShow }
