let imports = ./imports.dhall

let Map = imports.Prelude.Map

let OS = (./OS/package.dhall).Type

let Outputs = ./Outputs.dhall

let Service = ./Service.dhall

let Step = ./Step.dhall

let Strategy = ./Strategy.dhall

let subst = ./subst.dhall

let Job =
      { Type =
          { runs-on : List OS
          , container : Optional Text
          , services : Map.Type Text Service.Type
          , steps : List Step.Type
          , outputs : Outputs.Type
          , needs : List Text
          , strategy : Optional Strategy.Type
          }
      , default =
        { container = None Text
        , services = Map.empty Text Service.Type
        , steps = [] : List Step.Type
        , outputs = Outputs.default
        , needs = [] : List Text
        , strategy = None Strategy.Type
        }
      }

let Entry = Map.Entry Text Job.Type

let jobs = imports.Prelude.List.concat Job.Type

let substOutput =
      λ(jobId : Text) → λ(name : Text) → subst "needs.${jobId}.outputs.${name}"

let _ =
        assert
      :   substOutput "my-job" "my_output"
        ≡ "\${{ needs.my-job.outputs.my_output }}"

in  Job ⫽ { Entry, jobs, substOutput }
