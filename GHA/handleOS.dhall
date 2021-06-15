-- I don't love this name, but 🤷 for now…
--
let imports = ./imports.dhall

let NonEmpty = imports.Prelude.NonEmpty

let Plural = (./imports.dhall).Plural

let List/ = imports.Prelude.List

let OS = ./OS/package.dhall

let multiOS = ./multiOS.dhall

let singleOS = ./singleOS.dhall

let handleOS =
      λ(os : NonEmpty.Type OS.Type) →
        merge
          { None = singleOS os.head
          , Some =
              λ(neck : OS.Type) →
                multiOS
                  ( Plural.make
                      OS.Type
                      os.head
                      neck
                      (List/.drop 1 OS.Type os.tail)
                  )
          }
          (List/.head OS.Type os.tail)

let _tests =
      let Optional/ = imports.Prelude.Optional

      let Strategy = ./Strategy.dhall

      let isSome = Optional/.null Strategy.Type

      let _singular =
            let os = OS.Type.other "foo"

            let result = handleOS (NonEmpty.singleton OS.Type os)

            let _test0 = assert : True ≡ isSome result.strategy

            let _test1 = assert : [ os ] ≡ result.runs-on

            in  <>

      let _plural =
            let os1 = OS.Type.other "os1"

            let os2 = OS.Type.other "os2"

            let os3 = OS.Type.other "os3"

            let os4 = OS.Type.other "os4"

            let result = handleOS (NonEmpty.make OS.Type os1 [ os2, os3, os4 ])

            let _test0 = assert : False ≡ isSome result.strategy

            let _test1 =
                    assert
                  : [ OS.Type.other "\${{ matrix.os }}" ] ≡ result.runs-on

            in  <>

      in  <>

in  handleOS
