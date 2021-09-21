# function to lookup reveal resource
reveal_resources <- function(...) {
  system.file("rmarkdown/templates/revealjs_presentation/resources",
              ...,
              package = "revealjs")
}

# Convert boolean from R to JS boolean
jsbool <- function(value) ifelse(value, "true", "false")