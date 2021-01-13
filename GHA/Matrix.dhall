-- This is only the most basic of what `matrix` supports. What's missing:
--
--   * arbitrary keys & values
--   * include
--   * exclude
--
let HostedRunner = ./HostedRunner.dhall

in  { Type =
        { os : List HostedRunner
        , fail-fast : Optional Bool
        , max-parallel : Optional Natural
        }
    , default =
      { os = [] : List HostedRunner
      , fail-fast = None Bool
      , max-parallel = None Natural
      }
    }
