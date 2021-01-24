λ(name : Text) →
λ(commitish : Text) →
  { links =
    { _repo = "https://github.com/${name}/tree/${commitish}"
    , action = "https://github.com/${name}/blob/${commitish}/action.yml"
    , actionRaw =
        "https://raw.githubusercontent.com/${name}/${commitish}/action.yml"
    }
  }
