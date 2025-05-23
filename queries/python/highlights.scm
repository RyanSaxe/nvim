; extends
(
  (identifier) @keyword.risky
  (#match? @keyword.risky "^(exec|eval)$")
)

[
  "assert"
  "raise"
  "except"
] @keyword.error
