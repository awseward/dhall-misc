let imports = ./imports.dhall

let Map = imports.Prelude.Map

let Outputs = ./Outputs.dhall

let Service = ./Service.dhall

let Step = ./Step.dhall

let Strategy = ./Strategy.dhall

let Job =
      { Type =
          { runs-on : List Text
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

in  Job ⫽ { Entry, jobs }
