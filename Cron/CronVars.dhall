let Bool/not =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/Bool/not sha256:723df402df24377d8a853afed08d9d69a0a6d86e2e5b2bac8960b0d4756c7dc4

let List/filter =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/List/filter sha256:8ebfede5bbfe09675f246c33eb83964880ac615c4b1be8d856076fdbc4b26ba6

let List/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/List/map sha256:dd845ffb4568d40327f2a817eb42d1c6138b929ca758d50bc33112ef3c885680

let List/null =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/List/null sha256:2338e39637e9a50d66ae1482c0ed559bbcc11e9442bfca8f8c176bbcd9c4fc80

let Map/Entry =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/Map/Entry sha256:f334283bdd9cd88e6ea510ca914bc221fc2dab5fb424d24514b2e0df600d5346

let Map/map =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/Map/map sha256:23e09b0b9f08649797dfe1ca39755d5e1c7cad2d0944bdd36c7a0bf804bde8d0

let Optional/null =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/Optional/null sha256:efc43103e49b56c5bf089db8e0365bbfc455b8a2f0dc6ee5727a3586f85969fd

let Optional/default =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/Optional/default sha256:8f802473931b605422b545d7b81de20dbecb38f2ae63950c13f5381865a7f012

let Text/concatSep =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v11.1.0/Prelude/Text/concatSep sha256:e4401d69918c61b92a4c0288f7d60a6560ca99726138ed8ebc58dca2cd205e58

let KOptV = Map/Entry Text (Optional Text)

let KV = Map/Entry Text Text

let tryShow =
        λ(map : List KOptV)
      → let filtered =
              List/filter
                KOptV
                (λ(kOv : KOptV) → Bool/not (Optional/null Text kOv.mapValue))
                map
        
        let someValKVs =
              Map/map
                Text
                (Optional Text)
                Text
                (Optional/default Text "")
                filtered
        
        in        if Bool/not (List/null KV someValKVs)
            
            then  let sep = "\n"
                  
                  in  Some
                        ( Text/concatSep
                            sep
                            ( List/map
                                KV
                                Text
                                (   λ(kv : KV)
                                  → Text/concatSep
                                      "="
                                      [ kv.mapKey, kv.mapValue ]
                                )
                                someValKVs
                            )
                        )
            
            else  None Text

let show = λ(map : List KOptV) → Optional/default Text "" (tryShow map)

let _example =
      let map = toMap { FOO = Some "this_is_foo", bar = None Text }
      
      let expected = "FOO=this_is_foo"
      
      let _ = assert : tryShow map ≡ Some expected
      
      let _ = assert : show map ≡ expected
      
      in  {}

in  { tryShow = tryShow }
