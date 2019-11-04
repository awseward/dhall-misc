let ApiVersion = ./Type.dhall

in  λ(version : ApiVersion.Type) → merge { v3 = "v3", v4 = "v4" } version
