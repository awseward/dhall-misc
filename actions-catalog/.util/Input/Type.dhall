let imports = ../../imports.dhall

let JSON = imports.JSON

in  { default : Optional JSON.Type, required : Optional Bool }
