let template = ./template/package.dhall as Text

in  λ(owner : Text) →
    λ(action : Text) →
    λ(tag : Text) →
      Text/replace
        "__owner__"
        owner
        (Text/replace "__action__" action (Text/replace "__tag__" tag template))
