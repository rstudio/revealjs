#' Convert to a reveal.js presentation
#'
#' Format for converting from R Markdown to a reveal.js presentation.
#'
#' @inheritParams rmarkdown::beamer_presentation
#' @inheritParams rmarkdown::pdf_document
#' @inheritParams rmarkdown::html_document
#'
#' @param center \code{TRUE} to vertically center content on slides
#' @param theme Visual theme ("simple", "sky", "beige", "serif", 
#'   "solarized", "blood", "moon", "night", "black", "league" or "white").
#' @param transition Slide transition ("default", "none", "fade", "slide", 
#'   "convex", "concave" or "zoom")
#' @param background_transition Slide background-transition ("default", "none", "fade", "slide", 
#'   "convex", "concave" or "zoom")
#' @param history \code{TRUE} to push each slide change to the browser history.
#' @param template Pandoc template to use for rendering. Pass "default"
#'   to use the rmarkdown package default template; pass \code{NULL}
#'   to use pandoc's built-in template; pass a path to use a custom template
#'   that you've created. Note that if you don't use the "default" template
#'   then some features of \code{revealjs_presentation} won't be available
#'   (see the Templates section below for more details).
#' @param ... Ignored
#'
#' @return R Markdown output format to pass to \code{\link{render}}
#'
#' @details
#'
#' In reveal.js presentations you can use level 1 or level 2 headers for
#' slides. If you use a mix of level 1 and level 2 headers then a
#' two-dimensional layout will be produced, with level 1 headers building
#' horizontally and level 2 headers building vertically.
#'
#' For more information on markdown syntax for presentations see
#' \href{http://johnmacfarlane.net/pandoc/demo/example9/producing-slide-shows-with-pandoc.html}{producing
#' slide shows with pandoc}.
#'
#' @section Templates:
#'
#' You can provide a custom HTML template to be used for rendering. The syntax
#' for templates is described in the documentation on
#' \href{http://johnmacfarlane.net/pandoc/demo/example9/templates.html}{pandoc
#' templates}. You can also use the basic pandoc template by passing
#' \code{template = NULL}.
#'
#' Note however that if you choose not to use the "default" reveal.js template
#' then several aspects of reveal.js presentation rendering will behave
#' differently:
#'
#' \itemize{
#'   \item{The \code{center} parameter does not work (you'd need to
#'      set this directly in the template).
#'   }
#'   \item{The built-in template includes some additional tweaks to styles
#'      to optimize for output from R, these won't be present.
#'   }
#'   \item{MathJax will not work if \code{self_contained} is \code{TRUE}
#'      (these two options can't be used together in normal pandoc templates).
#'   }
#' }
#'
#' @examples
#' \dontrun{
#'
#' library(rmarkdown)
#' library(revealjs)
#'
#' # simple invocation
#' render("pres.Rmd", revealjs_presentation())
#'
#' # specify an option for incremental rendering
#' render("pres.Rmd", revealjs_presentation(incremental = TRUE))
#' }
#'
#'
#' @export
revealjs_presentation <- function(incremental = FALSE,
                                  center = FALSE,
                                  fig_width = 8,
                                  fig_height = 6,
                                  fig_retina = if (!fig_caption) 2,
                                  fig_caption = FALSE,
                                  smart = TRUE,
                                  self_contained = TRUE,
                                  theme = "simple",
                                  transition = "default",
                                  background_transition = "default",
                                  history = TRUE,
                                  highlight = "default",
                                  mathjax = "default",
                                  template = "default",
                                  css = NULL,
                                  includes = NULL,
                                  keep_md = FALSE,
                                  lib_dir = NULL,
                                  pandoc_args = NULL,
                                  ...) {
  
  # function to lookup reveal resource
  reveal_resources <- function() {
    system.file("rmarkdown/templates/revealjs_presentation/resources",
                package = "revealjs")
  }
  
  # base pandoc options for all reveal.js output
  args <- c()
  
  # template path and assets
  if (identical(template, "default")) {
    default_template <- system.file(
      "rmarkdown/templates/revealjs_presentation/resources/default.html",
      package = "revealjs"
    )
    args <- c(args, "--template", pandoc_path_arg(default_template))
  } else if (!is.null(template)) {
    args <- c(args, "--template", pandoc_path_arg(template))
  }
  
  # incremental
  if (incremental)
    args <- c(args, "--incremental")
  
  # centering
  jsbool <- function(value) ifelse(value, "true", "false")
  args <- c(args, pandoc_variable_arg("center", jsbool(center)))
  
  # theme
  theme <- match.arg(theme, revealjs_themes())
  if (identical(theme, "default"))
    theme <- "simple"
  else if (identical(theme, "dark"))
    theme <- "black"
  if (theme %in% c("blood", "moon", "night", "black"))
    args <- c(args, "--variable", "theme-dark")
  args <- c(args, "--variable", paste("theme=", theme, sep=""))
  
  
  # transition
  transition <- match.arg(transition, revealjs_transitions())
  args <- c(args, "--variable", paste("transition=", transition, sep=""))
  
  # background_transition
  background_transition <- match.arg(background_transition, revealjs_transitions())
  args <- c(args, "--variable", paste("backgroundTransition=", background_transition, sep=""))
  
  # history
  args <- c(args, pandoc_variable_arg("history", jsbool(history)))
  
  # content includes
  args <- c(args, includes_to_pandoc_args(includes))
  
  # additional css
  for (css_file in css)
    args <- c(args, "--css", pandoc_path_arg(css_file))
  
  # pre-processor for arguments that may depend on the name of the
  # the input file (e.g. ones that need to copy supporting files)
  pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir,
                            output_dir) {
    
    # use files_dir as lib_dir if not explicitly specified
    if (is.null(lib_dir))
      lib_dir <- files_dir
    
    # extra args
    args <- c()
    
    # reveal.js
    revealjs_path <- system.file("reveal.js-3.2.0", package = "revealjs")
    if (!self_contained || identical(.Platform$OS.type, "windows"))
      revealjs_path <- relative_to(
        output_dir, render_supporting_files(revealjs_path, lib_dir))
    args <- c(args, "--variable", paste("revealjs-url=",
                                        pandoc_path_arg(revealjs_path), sep=""))
    
    # highlight
    args <- c(args, pandoc_highlight_args(highlight, default = "pygments"))
    
    # return additional args
    args
  }
  
  # return format
  output_format(
    knitr = knitr_options_html(fig_width, fig_height, fig_retina, keep_md),
    pandoc = pandoc_options(to = "revealjs",
                            from = rmarkdown_format(ifelse(fig_caption, 
                                                           "", 
                                                           "-implicit_figures")),
                            args = args),
    keep_md = keep_md,
    clean_supporting = self_contained,
    pre_processor = pre_processor,
    base_format = html_document_base(smart = smart, lib_dir = lib_dir,
                                     self_contained = self_contained,
                                     mathjax = mathjax,
                                     pandoc_args = pandoc_args, ...))
}

revealjs_themes <- function() {
  c("default",
    "dark",
    "simple",
    "sky",
    "beige",
    "serif",
    "solarized",
    "blood",
    "moon",
    "night",
    "black",
    "league",
    "white")
}


revealjs_transitions <- function() {
  c(
    "default",
    "none",
    "fade",
    "slide",
    "convex",
    "concave",
    "zoom"
    )
}


