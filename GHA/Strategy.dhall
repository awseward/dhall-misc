let Matrix = ./Matrix.dhall

in  { Type = { matrix : Matrix.Type }, default.matrix = Matrix::{=}, Matrix }
