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
