let ApiVersion = < v3 | v4 >

let show = λ(ghV : ApiVersion) → merge { v3 = "v3", v4 = "v4" } ghV

in  { Type = ApiVersion, default = ApiVersion.v3, show = show }
