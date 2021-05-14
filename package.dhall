{ GHA = ./GHA/package.dhall
, actions-catalog = ./actions-catalog/package.dhall
, job-templates =
    -- Maybe consider calling this workflow-templates instead
    ./job-templates/package.dhall
}
