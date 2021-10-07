################################################ 
# Script to update reveal.js resources         #
# - To document steps so to execute  manually  #
################################################


# 01 - Update reveal.js library ------------------------------------------------

## Main workflow:
##   * Download new release
##   * move plugins specific to revealjs package
##   * Check using version control the differences
##   * Adapt the code base if necessary
## 
## Notes from updates
##
## 3.3 -> 4.1.2 (27/09/2021): 
##  * Upgrade notes: https://revealjs.com/upgrading/
##  * note-server and multiplex plugins where removed, but they weren't use in the package
##  * JS and CSS files were moved to dist/, including themes/
##  * css/monokai moved to plugin/highlight
##  * print CSS were removed
##  * head.min.js deleted
##  * Plugin registration has changed
##  * html5shiv deleted


# download latest source
dir.create(tmp_dir <- tempfile())
owd <- setwd(tmp_dir)
latest <- xfun::github_releases("hakimel/reveal.js", pattern = "([0-9.]+)")[1]
url <- sprintf("https://github.com/hakimel/reveal.js/archive/refs/tags/%s.zip", latest)
xfun::download_file(url)
fs::dir_ls()
unzip(basename(url))
reveal_folder <- fs::path_abs(fs::dir_ls(glob = "reveal.js-*"))
setwd(owd)

# Replace the library in the package 
current <- fs::dir_ls("inst", glob = "*/reveal.js-*")
new <- fs::path("inst", fs::path_file(reveal_folder), "/")
fs::dir_copy(reveal_folder, fs::path("inst", fs::path_file(reveal_folder)), overwrite = TRUE)

# move non-core plugins to new library folder
plugins <- c("chalkboard", "menu")
purrr::walk(plugins, ~{
  fs::dir_copy(fs::path(current, "plugin", .x), fs::path(new, "plugin", .x))
})

# Delete old version
fs::dir_delete(current)

# Stage file to look at differences
gert::git_add("inst/")

fs::dir_delete(tmp_dir)

# Update .Rbuildignore
current <- fs::dir_ls("inst", glob = "*/reveal.js-*")
buildignore <- xfun::read_utf8(".Rbuildignore")
i <- grep("inst/reveal", buildignore)
buildignore <- buildignore[-i]
ignore <- fs::dir_ls(current, regexp = ".*(dist|plugin|LICENSE|README.md).*", invert = TRUE, all = TRUE)
ignore_reg <- gsub("reveal\\.js-[^/]*", "reveal\\.js-[^/]+", ignore)
xfun::write_utf8(c(buildignore, ignore_reg), ".Rbuildignore")

# Make fonts local -------------------------------------------------------

current <- fs::dir_ls("inst", glob = "*/reveal.js-*")
themes <- fs::dir_ls(fs::path(current, "dist", "theme"), glob = "*.css")
themes <- purrr::set_names(themes, nm = fs::path_file(fs::path_ext_remove(themes)))
url_fonts <- purrr::map(themes, ~ {
  css_theme <- xfun::read_utf8(.x)
  fonts <- stringr::str_extract(css_theme, "(?<=@import url\\()https://[^)]+")
  as.character(na.omit(fonts))
})
fonts <- unique(purrr::simplify(url_fonts))
sort(fonts)

# is there duplicate font ? 
dup <- duplicated(purrr::map_chr(stringr::str_match_all(fonts, "(?<=family=)([^:]+)"), ~ .x[1,1]))
fonts[dup]

# if this is ok download theme
get_fonts <- purrr::map(fonts, ~ {
    font_url <- .x
    if (!grepl("https://fonts.googleapis.com", font_url, fixed = TRUE)) stop("Not a good font. Handle manuallly.")
    # from sass:::font_dep_google_local
    tmpdir <- tempfile()
    dir.create(tmpdir, recursive = TRUE)
    css_file <- file.path(tmpdir, "font.css")
    css <- sass:::read_gfont_url(font_url, css_file)
    urls <- sass:::extract_group(css, "url\\(([^)]+)")
    family <- stringr::str_match_all(font_url, "(?<=family=)([^:]+)")[[1]][2]
    family <- sub("\\s+", "_", sass:::trim_ws(family))
    family <- sub("\\+", "-", family)
    basenames <- paste(family, seq_along(urls), sep = "-")
    basenames <- fs::path_ext_set(basenames, fs::path_ext(fs::path_file(urls)))
    Map(function(url, nm) {
      f <- file.path(tmpdir, nm)
      xfun::download_file(url, f, mode = "wb")
      css <<- sub(url, nm, css, fixed = TRUE)
    }, urls, basenames)
    xfun::write_utf8(css, css_file)
    font <- list(name = family, dir = dirname(css_file), css = basename(css_file))
    fs::dir_create(font_folder <- fs::path(current, "dist", "theme", "fonts", font$name))
    fs::file_copy(fs::dir_ls(font$dir), font_folder, overwrite = TRUE)
    unlink(font$dir, recursive = TRUE)
    font
})

get_fonts <- purrr::set_names(get_fonts, fonts)
local_fonts <- purrr::map(get_fonts, ~ {
  font_folder <- fs::path(current, "dist", "theme", "fonts", .x$name)
  fs::path(".", fs::path_rel(fs::path(font_folder, .x$css), fs::path_dir(themes[1])))
})

for(theme in themes) {
  purrr::iwalk(local_fonts, ~ xfun::gsub_file(theme, pattern = .y, replacement = .x, fixed = TRUE))
}

gert::git_add(fs::path(current, "dist", "theme"))


# Update plugins ----------------------------------------------------------

revealjs_lib <- fs::dir_ls("inst", glob = "*/reveal.js-*")
stopifnot(length(revealjs_lib) == 1)

## MENU PLUGGINS
## https://github.com/denehyg/reveal.js-menu
dir.create(tmp_dir <- tempfile())
owd <- setwd(tmp_dir)
latest <- xfun::github_releases("denehyg/reveal.js-menu", pattern = "([0-9.]+)")[1]
url <- sprintf("https://github.com/denehyg/reveal.js-menu/archive/refs/tags/%s.zip", latest)
xfun::download_file(url)
fs::dir_ls()
unzip(basename(url))
new_plugin <- fs::path_abs(fs::dir_ls(glob = "reveal.js-*"))
setwd(owd)

### keep only necessary resources
plugin_folder <- fs::path(revealjs_lib, "plugin", "menu")
fs::dir_delete(plugin_folder)
to_keep <- c("menu.css", "menu.js", "LICENSE")
fs::dir_create(plugin_folder)
fs::file_copy(fs::path(new_plugin, to_keep), fs::path(plugin_folder, to_keep), overwrite = TRUE)

### Create VERSION file
writeLines(latest, fs::path(plugin_folder, "VERSION"))

gert::git_add(plugin_folder)

## reveal.js-plugins repo
## https://github.com/rajgoel/reveal.js-plugins/

dir.create(tmp_dir <- tempfile())
owd <- setwd(tmp_dir)
latest <- xfun::github_releases("rajgoel/reveal.js-plugins", pattern = "([0-9.]+)")[1]
url <- sprintf("https://github.com/rajgoel/reveal.js-plugins/archive/refs/tags/%s.zip", latest)
xfun::download_file(url)
fs::dir_ls()
unzip(basename(url))
new_plugin <- fs::path_abs(fs::dir_ls(glob = "reveal.js-*"))
setwd(owd)

### keep only necessary resources
plugins_to_keep <- c("chalkboard", "customcontrols")
plugin_folders <- fs::path(revealjs_lib, "plugin", plugins_to_keep)
fs::dir_delete(plugin_folders[fs::dir_exists(plugin_folders)])
purrr::walk(plugin_folders, ~ {
  fs::dir_copy(fs::path(new_plugin, fs::path_file(.x)), .x, overwrite = TRUE)
  fs::file_copy(fs::path(new_plugin, "LICENSE"), .x, overwrite = TRUE)
  writeLines(latest, fs::path(.x, "VERSION"))
})

gert::git_add(plugin_folders)
