{-
inputs:
  nim-version:
    description: 'The Nim version to download (if necessary) and use. Example: 1.0.2'
    default: 'stable'
  no-color:
    description: 'Activate "--noColor" options of choosenim. Example: true'
    default: false
  yes:
    description: 'Activate "--yes" options of choosenim. Example: true'
    default: false
-}
--
{ nim-version : Optional Text, no-color : Optional Bool, yes : Optional Bool }
