{ GHA = ./GHA/package.dhall
, actions-catalog = ./actions-catalog/package.dhall
, action_templates =
    -- TODO: Remove this shim eventually…
    ./job-templates/package.dhall
, job-templates = ./job-templates/package.dhall
}
