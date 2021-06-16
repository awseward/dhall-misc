let handleOS = ./handleOS.dhall

let Job = ./Job.dhall

let NonEmpty = (./imports.dhall).Prelude.NonEmpty

let On = ./On.dhall

let OS = ./OS/package.dhall

let Step = ./Step.dhall

in  λ(defaultBranch : Text) →
    λ(os : NonEmpty.Type OS.Type) →
    λ(steps : List Step.Type) →
      { name = "Cache"
      , on =
          On.map
            [ On.push On.PushPull::{ branches = On.include [ defaultBranch ] } ]
      , jobs = toMap { update-cache = Job::(handleOS os ⫽ { steps }) }
      }
