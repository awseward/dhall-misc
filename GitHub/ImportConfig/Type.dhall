let ApiVersion = ../ApiVersion/Type.dhall

in  { Type = { token : Text, user-agent : Text, version : ApiVersion.Type }
    , default =
        { user-agent =
            "dhall-misc/??? (https://github.com/awseward/dhall-misc#README)"
        , version = ApiVersion.default
        }
    }
