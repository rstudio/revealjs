# function to lookup reveal resource
reveal_resources <- function(...) {
  system.file("rmarkdown/templates/revealjs_presentation/resources",
              ...,
              package = "revealjs")
}


revealjs_lib_path <- function(...) {
  pkg <- system.file(package = "revealjs")
  lib_folder <- list.files(pkg, pattern = "reveal.js-")[1]
  system.file(lib_folder, ..., package = "revealjs")
}

revealjs_version <- function() {
  as.numeric_version(gsub(".*reveal\\.js-(.*)$", "\\1", revealjs_lib_path()))
}

# Convert boolean from R to JS boolean
jsbool <- function(value) ifelse(value, "true", "false")

# transfrom reveal option as pandoc variable
process_reveal_option <- function(option, value) {
  if (is.logical(value)) {
    value <- jsbool(value)
  } else if (is.character(value)) {
    # Special handling for some vector options 
    if (
      # chalkboard plugin options
      # e.g: color: [ 'rgba(0,0,255,1)', 'rgba(255,255,255,0.5)' ]
      grepl("chalkboard-(background|draw)", option)
      # e.g autoAnimateStyles: ['opacity','color']
      || grepl("autoAnimateStyles", option)
    ) {
      if (length(value) > 1 || !grepl("^\\[.*\\]$", value)) {
        value <- sprintf("[%s]", paste(paste0("'", value, "'"), collapse = ", "))
      }
    }
    # Add quotes around some config that can be several type
    # like number or percent unit or slideNumber = true or slideNumber = 'c/t'
    if (
      option %in% c("slideNumber") ||
      (option %in% c("width", "height") && grepl("%$", value))) {
      value <- paste0("'", value, "'")
    }
  }
  pandoc_variable_arg(option, value)
}
