#' Convert to a reveal.js presentation
#'
#' Format for converting from R Markdown to a reveal.js presentation.
#' 
#' In reveal.js presentations you can use level 1 or level 2 headers for slides.
#' If you use a mix of level 1 and level 2 headers then a two-dimensional layout
#' will be produced, with level 1 headers building horizontally and level 2
#' headers building vertically.
#'
#' For additional documentation on using revealjs presentations see
#' <https://github.com/rstudio/revealjs>
#' 
#' # About plugins
#' 
#' ## Built-in plugins with reveal.js
#' 
#' ### Zoom 
#' 
#' When activated, ALT + Click can be used to zoom on a slide.
#' 
#' ### Notes 
#'  
#' Show a [speaker view](https://revealjs.com/speaker-view/) in a separated
#' window. This speaker view contains a timer, current slide, next slide, and
#' speaker notes. It also duplicate the window to have presentation mode
#' synchronized with main presentation.
#' 
#' Use 
#' ```markdown
#' ::: notes
#' Content of speaker notes
#' :::
#' ```
#' to create notes only viewable in presentation mode.
#' 
#' ### Search
#' 
#' When opt-in, it is possible to show a search box when pressing `CTRL + SHIFT +
#' F`. It will seach in the whole presentation, and highlight matched words. The
#' matches will also be highlighted in overview mode (pressing ESC to see all
#' slides in one scrollable view)
#' 
#' ## Menu 
#' 
#' A slideout menu plugin for Reveal.js to quickly jump to any slide by title.
#' 
#' Version `r version <- readLines(revealjs_lib_path("plugin", "menu", "VERSION"))` is
#' currently used and documentation for configurations can be found at
#' [denehyg/reveal.js-menu](https://github.com/denehyg/reveal.js-menu/blob/`r version`/README.md)
#' 
#' ### Known limitations
#' 
#' Some configurations cannot be modified in the current template: 
#' 
#' * `loadIcons: false`  the fontawesome icons are loaded by \pkg{rmarkdown}
#' when this plugin is used
#' * `custom: false`
#' * `themes: false`
#' * `transitions: false`

#' ## Chalkboard 
#' 
#' A plugin adding a chalkboard and slide annotation
#' 
#' Version `r version <- readLines(revealjs_lib_path("plugin", "chalkboard", "VERSION"))` is
#' currently used and documentation for configurations can be found at
#' [rajgoel/reveal.js-plugins](https://github.com/rajgoel/reveal.js-plugins/tree/`r version`/chalkboard)
#' 
#' By default, chalkboard and annotations modes will be accessible using keyboard
#' shortcuts, respectively, pressing B, or pressing C.  
#' In addition, buttons on the bottom left can be added by using the following 
#' 
#' ```yaml
#' reveal_plugins: 
#'   - chalkboard
#' reveal_options:
#'   chalkboard:
#'     toggleNotesButton: true
#'     toggleChalkboardButton: true
#' ```
#' @inheritParams rmarkdown::beamer_presentation
#' @inheritParams rmarkdown::pdf_document
#' @inheritParams rmarkdown::html_document
#'
#' @param center `TRUE` to vertically center content on slides
#' @param slide_level Level of heading to denote individual slides. If
#'   `slide_level` is 2 (the default), a two-dimensional layout will be
#'   produced, with level 1 headers building horizontally and level 2 headers
#'   building vertically. It is not recommended that you use deeper nesting of
#'   section levels with reveal.js.
#' @param theme Visual theme (`r knitr::combine_words(setdiff(revealjs_themes(), "default"), before = '"', and = " or ")`)
#' @param transition Slide transition (
#' `r (trans <- knitr::combine_words(setdiff(revealjs_transitions(), "default"), before = '"', and = " or "))`
#' )
#' @param background_transition Slide background-transition (
#' `r trans`
#' )
#' @param reveal_options Additional options to specify for reveal.js (see
#'   <https://revealjs.com/config/> for details). Options for plugins can also
#'   be passed, using plugin name as first level key (e.g `list(slideNumber =
#'   FALSE, menu = list(number = TRUE))`).
#' @param reveal_plugins Reveal plugins to include. Available plugins include
#'   "notes", "search", "zoom", "chalkboard", and "menu". Note that
#'   `self_contained` must be set to `FALSE` in order to use Reveal
#'   plugins.
#' @param template Pandoc template to use for rendering. Pass "default" to use
#'   the rmarkdown package default template; pass `NULL` to use pandoc's
#'   built-in template; pass a path to use a custom template that you've
#'   created. Note that if you don't use the "default" template then some
#'   features of `revealjs_presentation` won't be available (see the
#'   Templates section below for more details).
#' @param extra_dependencies Additional function arguments to pass to the base R
#'   Markdown HTML output formatter [rmarkdown::html_document_base()].
#' @param ... Ignored
#'
#' @return R Markdown output format to pass to [rmarkdown::render()]
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
#' @export
revealjs_presentation <- function(incremental = FALSE,
                                  center = FALSE,
                                  slide_level = 2,
                                  toc = FALSE,
                                  toc_depth = 3,
                                  fig_width = 8,
                                  fig_height = 6,
                                  fig_retina = if (!fig_caption) 2,
                                  fig_caption = FALSE,
                                  self_contained = TRUE,
                                  theme = "simple",
                                  transition = "convex",
                                  background_transition = "fade",
                                  reveal_options = NULL,
                                  reveal_plugins = NULL,
                                  highlight = "default",
                                  mathjax = "default",
                                  template = "default",
                                  css = NULL,
                                  includes = NULL,
                                  keep_md = FALSE,
                                  lib_dir = NULL,
                                  pandoc_args = NULL,
                                  extra_dependencies = NULL,
                                  md_extensions = NULL,
                                  ...) {

  # base pandoc options for all reveal.js output
  args <- c()
  
  # table of contents
  args <- c(args, pandoc_toc_args(toc, toc_depth))

  # template path and assets
  if (identical(template, "default")) {
    default_template <- reveal_resources("default.html")
    args <- c(args, "--template", pandoc_path_arg(default_template))
  } else if (!is.null(template)) {
    args <- c(args, "--template", pandoc_path_arg(template))
  }

  # incremental
  if (incremental) args <- c(args, "--incremental")

  # centering
  args <- c(args, pandoc_variable_arg("center", jsbool(center)))

  # slide level
  args <- c(args, "--slide-level", as.character(slide_level))

  # theme
  theme <- match.arg(theme, revealjs_themes())
  if (identical(theme, "default")) {
    theme <- "simple"
  } else if (identical(theme, "dark")) {
    theme <- "black"
  }
  if (theme %in% c("blood", "moon", "night", "black")) {
    args <- c(args, pandoc_variable_arg("theme-dark"))
  }
  args <- c(args, pandoc_variable_arg("theme", theme))


  # transition
  transition <- match.arg(transition, revealjs_transitions())
  if (identical(transition, "default")) {
    # revealjs default is convex
    transition <- "convex"
  }
  args <- c(args, pandoc_variable_arg("transition", transition))

  # background_transition
  background_transition <- match.arg(background_transition, revealjs_transitions())
  if (identical(background_transition, "default")) {
    # revealjs default is fade
    background_transition <- "fade"
  }
  args <- c(args, pandoc_variable_arg("backgroundTransition", background_transition))

  # use history
  args <- c(args, pandoc_variable_arg("history", "true"))

  # additional reveal options
  if (is.list(reveal_options)) {
    for (option in names(reveal_options)) {
      # special handling for nested options
      if (option %in% c("chalkboard", "menu")) {
        nested_options <- reveal_options[[option]]
        for (nested_option in names(nested_options)) {
          args <- c(args, 
                    process_reveal_option(
                      paste0(option, "-", nested_option),
                      nested_options[[nested_option]]
                    )
          )
        }
      } else { 
        # standard top-level options
        args <- c(args, process_reveal_option(option, reveal_options[[option]]))
      }
    }
  }

  # reveal plugins
  if (is.character(reveal_plugins)) {

    # validate that we need to use self_contained for plugins
    if (self_contained) {
      stop("Using reveal_plugins requires self_contained: false")
    }

    # validate specified plugins are supported
    supported_plugins <- c("notes", "search", "zoom", "chalkboard", "menu")
    invalid_plugins <- setdiff(reveal_plugins, supported_plugins)
    if (length(invalid_plugins) > 0) {
      stop("The following plugin(s) are not supported: ",
        paste(invalid_plugins, collapse = ", "),
        call. = FALSE
      )
    }

    # add plugins
    if ("chalkboard" %in% reveal_plugins) {
      # chalkboard require customcontrols so we add it to activate in the template
      reveal_plugins <- c(reveal_plugins, "customcontrols")
    }
    sapply(reveal_plugins, function(plugin) {
      args <<- c(args, pandoc_variable_arg(paste0("plugin-", plugin)))
      if (plugin %in% c("customcontrols", "menu")) {
        extra_dependencies <<- append(
          extra_dependencies,
          list(rmarkdown::html_dependency_font_awesome())
        )
      }
    })
  }

  # content includes
  args <- c(args, includes_to_pandoc_args(includes))

  # additional css
  for (css_file in css) {
    args <- c(args, "--css", pandoc_path_arg(css_file))
  }

  # pre-processor for arguments that may depend on the name of the
  # the input file (e.g. ones that need to copy supporting files)
  pre_processor <- function(metadata, input_file, runtime, knit_meta, files_dir,
                            output_dir) {

    # we don't work with runtime shiny
    if (identical(runtime, "shiny")) {
      stop("revealjs_presentation is not compatible with runtime 'shiny'",
        call. = FALSE
      )
    }

    # use files_dir as lib_dir if not explicitly specified
    if (is.null(lib_dir)) {
      lib_dir <- files_dir
    }

    # extra args
    args <- c()

    # reveal.js
    revealjs_path <- revealjs_lib_path()
    if (!self_contained || identical(.Platform$OS.type, "windows")) {
      revealjs_path <- relative_to(
        output_dir, render_supporting_files(revealjs_path, lib_dir)
      )
    } else {
      revealjs_path <- pandoc_path_arg(revealjs_path)
    }
    args <- c(args, pandoc_variable_arg("revealjs-url", revealjs_path))

    # highlight
    args <- c(args, pandoc_highlight_args(highlight, default = "pygments"))

    # return additional args
    args
  }

  # return format
  output_format(
    knitr = knitr_options_html(fig_width, fig_height, fig_retina, keep_md),
    pandoc = pandoc_options(
      to = "revealjs",
      from = from_rmarkdown(fig_caption, md_extensions),
      args = args
    ),
    keep_md = keep_md,
    clean_supporting = self_contained,
    pre_processor = pre_processor,
    base_format = html_document_base(
      lib_dir = lib_dir,
      self_contained = self_contained,
      mathjax = mathjax,
      pandoc_args = pandoc_args,
      extra_dependencies = extra_dependencies,
      ...
    )
  )
}

revealjs_themes <- function() {
  c(
    "default", # not used by reveal
    "simple",
    "dark", # our alias for black
    "black",
    "sky",
    "beige",
    "serif",
    "solarized",
    "blood",
    "moon",
    "night",
    "league",
    "white"
  )
}

revealjs_transitions <- function() {
  c(
    "default", # not used by reveal
    "convex",
    "fade",
    "slide",
    "concave",
    "zoom",
    "none"
  )
}
