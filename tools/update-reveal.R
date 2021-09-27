# Script to update reveal.js library
# 
# Main workflow:
#   * Download new release
#   * move plugins specific to revealjs package
#   * Check using version control the differences
#   * Adapt the code base if necessary
# 
# Notes from updates
#
# 3.3 -> 4.1.2 (27/09/2021): 
#  * Upgrade notes: https://revealjs.com/upgrading/
#  * note-server and multiplex plugins where removed, but they weren't use in the package
#  * JS and CSS files were moved to dist/, including themes/
#  * css/monokai moved to plugin/highlight
#  * print CSS were removed
#  * head.min.js deleted
#  * Plugin registration has changed
#  * html5shiv deleted

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
