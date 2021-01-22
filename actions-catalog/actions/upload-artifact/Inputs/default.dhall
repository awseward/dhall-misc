{ if-no-files-found =
    ''
    ===================================================================
    NOTE: You probably want to change the type of this to `Optional a`,
    and not provide a default value here of `None a`, where `a` is
    whatever type seems to make sense for this field.
    -------------------------------------------------------------------

    Original Description
    --------------------
    The desired behavior if no files are found using the provided path.
    Available Options:
      warn: Output a warning but do not fail the action
      error: Fail the action with an error message
      ignore: Do not output any warnings or errors, the action does not fail
    ''
, name =
    ''
    ===================================================================
    NOTE: You probably want to change the type of this to `Optional a`,
    and not provide a default value here of `None a`, where `a` is
    whatever type seems to make sense for this field.
    -------------------------------------------------------------------

    Original Description
    --------------------
    Artifact name
    ''
, retention-days =
    ''
    ===================================================================
    NOTE: You probably want to change the type of this to `Optional a`,
    and not provide a default value here of `None a`, where `a` is
    whatever type seems to make sense for this field.
    -------------------------------------------------------------------

    Original Description
    --------------------
    Duration after which artifact will expire in days. 0 means using default retention.
    Minimum 1 day. Maximum 90 days unless changed from the repository settings page.
    ''
}
