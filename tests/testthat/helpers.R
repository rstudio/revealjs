local_temp_rmd_file <- function(..., .env = parent.frame()) {
  path <- withr::local_tempfile(.local_envir = .env, fileext = ".Rmd")
  xfun::write_utf8(c(...), path)
  path
}

local_temp_draft <- function(.env = parent.frame()) {
  path <- withr::local_tempfile(.local_envir = .env, fileext = ".Rmd")
  # TODO: Use `rmarkdown::draft()` when rmarkdown 2.12 is out.
  pkg_file <- getFromNamespace("pkg_file", "rmarkdown")
  template_path <- pkg_file(
    "rmarkdown",
    "templates",
    "revealjs_presentation",
    package = "revealjs"
  )
  rmarkdown::draft(path, template_path, edit = FALSE)
}

.render_and_read <- function(input, xml = TRUE, ...) {
  skip_if_not_pandoc()
  output_file <- withr::local_tempfile(fileext = ".html")
  res <- rmarkdown::render(input, output_file = output_file, quiet = TRUE, ...)
  if (xml) {
    xml2::read_html(res)
  } else {
    xfun::read_utf8(res)
  }
}

# Use to test pandoc availability or version lower than
skip_if_not_pandoc <- function(ver = NULL) {
  if (!pandoc_available(ver)) {
    msg <- if (is.null(ver)) {
      "Pandoc is not available"
    } else {
      sprintf("Version of Pandoc is lower than %s.", ver)
    }
    skip(msg)
  }
}

# Use to test version greater than
skip_if_pandoc <- function(ver = NULL) {
  if (pandoc_available(ver)) {
    msg <- if (is.null(ver)) {
      "Pandoc is available"
    } else {
      sprintf("Version of Pandoc is greater than %s.", ver)
    }
    skip(msg)
  }
}
