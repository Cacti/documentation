# customize style guide
all
rule "MD013", code_blocks: false, tables: false
rule "MD029", style: "ordered"
rule "MD046", style: "fenced"

# Rule Exclusions
exclude_rule "MD001" # Headers are useful in other ways
exclude_rule "MD024" # Headers with same name are useful, but break link labeling (Rework needed on affected files before enabling this rule)
exclude_rule "MD046" # seems broken
