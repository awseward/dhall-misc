let List/filter =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/List/filter
        sha256:8ebfede5bbfe09675f246c33eb83964880ac615c4b1be8d856076fdbc4b26ba6

let List/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/List/map
        sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let List/null =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/List/null
        sha256:2338e39637e9a50d66ae1482c0ed559bbcc11e9442bfca8f8c176bbcd9c4fc80

let Map/Entry =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Map/Entry
        sha256:f334283bdd9cd88e6ea510ca914bc221fc2dab5fb424d24514b2e0df600d5346

let Map/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Map/map
        sha256:23e09b0b9f08649797dfe1ca39755d5e1c7cad2d0944bdd36c7a0bf804bde8d0

let Optional/some =
      let Optional/any =
            https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Optional/any
              sha256:96a5cf4f31b3c598b09161dd3082f0a09f4328a4cefda6a7e09894b37b17b435

      in  λ(t : Type) → λ(a : Optional t) → Optional/any t (λ(_ : t) → True) a

let Optional/default =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Optional/default
        sha256:5bd665b0d6605c374b3c4a7e2e2bd3b9c1e39323d41441149ed5e30d86e889ad

let Text/concatSep =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Text/concatSep
        sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

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
