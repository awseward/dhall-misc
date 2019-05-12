  λ(token : Text)
→ [ { header = "Authorization", value = "token ${token}" }
  , { header = "Accept", value = "application/vnd.github.v3.raw" }
  , { header = "User-Agent", value = "DhallImportsCustomHeadersTest" }
  ]
