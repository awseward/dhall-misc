let GHA = ../../GHA/package.dhall

let Step = GHA.Step

let With = { Type = { path : Text, key : Text }, default = {=} }

let Opts =
      { Type = Step.Common.Type ⩓ { `with` : With.Type }
      , default = Step.Common.default ∧ { `with` = With.default }
      }

let step =
      λ(opts : Opts.Type) →
        Step.mkUses
          opts.{ id, `if`, name, env, continue-on-error, timeout-minutes }
          Step.Uses::{ uses = "actions/cache@v1", `with` = toMap opts.`with` }

in  { step, Opts, With }
