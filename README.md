R Markdown Format for reveal.js Presentations
================

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/revealjs)](https://CRAN.R-project.org/package=revealjs)
[![R-CMD-check](https://github.com/rstudio/revealjs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rstudio/revealjs/actions/workflows/R-CMD-check.yaml)
[![reveal.js](https://img.shields.io/badge/reveal.js-4.2.1-yellow)](https://github.com/rstudio/revealjs/tree/main/inst/reveal.js-4.2.1)
<!-- badges: end -->

## Overview

This repository provides an [R Markdown](https://rmarkdown.rstudio.com)
custom format for [reveal.js](https://revealjs.com/) HTML presentations.
The packages includes *reveal.js* library in version 4.2.1

You can use this format in R Markdown documents by installing this
package as follows:

``` r
install.packages("revealjs")
```

To create a [reveal.js](https://revealjs.com/) presentation from R
Markdown you specify the `revealjs_presentation` output format in the
front-matter of your document. You can create a slide show broken up
into sections by using the `#` and `##` heading tags (you can also
create a new slide without a header using a horizontal rule (`----`).
For example here’s a simple slide show:

``` markdown
---
title: "Habits"
author: John Doe
date: March 22, 2005
output: revealjs::revealjs_presentation
---

# In the morning

## Getting up

- Turn off alarm
- Get out of bed

## Breakfast

- Eat eggs
- Drink coffee

# In the evening

## Dinner

- Eat spaghetti
- Drink wine

## Going to sleep

- Get in bed
- Count sheep
```

## Rendering

Depending on your use case, there are 3 ways you can render the
presentation.

1.  RStudio
2.  R console
3.  Terminal (e.g., bash)

### RStudio

When creating the presentation in RStudio, there will be a `Knit` button
right below the source tabs. By default, it will render the current
document and place the rendered `HTML` file in the same directory as the
source file, with the same name.

### R Console

The `Knit` button is actually calling the `rmarkdown::render()`
function. So, to render the document within the R console:

``` r
rmarkdown::render('my_reveal_presentation.Rmd')
```

There are many other output tweaks you can use by directly calling
`render`. You can read up on the
[documentation](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
for more details.

### Command Line

When you need the presentation to be rendered from the command line:

``` bash
Rscript -e "rmarkdown::render('my_reveal_presentation.Rmd')"
```

## Display Modes

The following single character keyboard shortcuts enable alternate
display modes:

- `'f'` enable fullscreen mode

- `'o'` enable overview mode

- `'b'` enable pause mode with a black screen hiding slide content

- `'?'` enable help mode to show keyboard shortcut cheatsheet

- `'s'` enable presentation mode with speaker notes when the Notes
  plugin is activated

- `'m'` enable menu mode when the ‘menu’ plugin is activated

Pressing `Esc` exits all of these modes.

## Incremental Bullets

You can render bullets incrementally by adding the `incremental` option:

``` yaml
---
output:
  revealjs::revealjs_presentation:
    incremental: true
---
```

If you want to render bullets incrementally for some slides but not
others you can use this syntax:

``` markdown
::: incremental

- Eat spaghetti
- Drink wine

:::
```

or

``` markdown
::: nonincremental

- Eat spaghetti
- Drink wine

:::
```

## Incremental Revealing

You can also add pauses between content on a slide using `. . .`

``` markdown
# Slide header

Content shown first

. . .

Content shown next on the same slide
```

Using Fragments explicitly is also possible

``` markdown
# Slide header

Content shown first

::: fragment
Content shown next on the same slide
:::
```

## Appearance and Style

There are several options that control the appearance of revealjs
presentations:

- `theme` specifies the theme to use for the presentation (available
  themes are “simple”, “dark”, “black”, “sky”, “beige”, “serif”,
  “solarized”, “blood”, “moon”, “night”, “league”, or “white”

- `highlight` specifies the syntax highlighting style. Supported styles
  include “default”, “tango”, “pygments”, “kate”, “monochrome”,
  “espresso”, “zenburn”, “haddock”, or “breezedark”. Pass null to
  prevent syntax highlighting.

- `center` specifies whether you want to vertically center content on
  slides (this defaults to false).

For example:

``` yaml
output:
  revealjs::revealjs_presentation:
    theme: sky
    highlight: pygments
    center: true
```

[Revealjs documentation about themes](https://revealjs.com/themes/)

## Slide Transitions

You can use the `transition` and `background_transition` options to
specify the global default slide transition style:

- `transition` specifies the visual effect when moving between slides.
  Available transitions are “convex”, “fade”, “slide”, “concave”,
  “zoom”, or “none”.

- `background_transition` specifies the background transition effect
  when moving between full page slides. Available transitions are
  “convex”, “fade”, “slide”, “concave”, “zoom”, or “none”

For example:

``` yaml
output:
  revealjs::revealjs_presentation:
    transition: fade
    background_transition: slide
```

You can override the global transition for a specific slide by using the
data-transition attribute, for example:

``` markdown
## Use a zoom transition {data-transition="zoom"}

## Use a faster speed {data-transition-speed="fast"}
```

You can also use different in and out transitions for the same slide,
for example:

``` markdown
## Fade in, Slide out {data-transition="slide-in fade-out"}

## Slide in, Fade out {data-transition="fade-in slide-out"}
```

This works also for background transition

``` markdown
## Use a zoomed background transition {data-background-transition="zoom"}
```

[Revealjs documentation about
transitions](https://revealjs.com/transitions/)

## Slide Backgrounds

Slides are contained within a limited portion of the screen by default
to allow them to fit any display and scale uniformly. You can apply full
page backgrounds outside of the slide area by adding a data-background
attribute to your slide header element. Four different types of
backgrounds are supported: color, image, video and iframe. Below are a
few examples.

``` markdown
## CSS color background {data-background-color=#ff0000}

## Full size image background {data-background-image="background.jpeg"}

## Video background {data-background-video="background.mp4"}

## Embed a web page as a background {data-background-iframe="https://example.com"}
```

Backgrounds transition using a fade animation by default. This can be
changed to a linear sliding transition by specifying the
`background-transition: slide`. Alternatively you can set
`data-background-transition` on any slide with a background to override
that specific transition.

[Revealjs documentation about
backgrounds](https://revealjs.com/backgrounds/)

## 2-D Presentations

You can use the `slide_level` option to specify which level of heading
will be used to denote individual slides. If `slide_level` is 2 (the
default), a two-dimensional layout will be produced, with level 1
headers building horizontally and level 2 headers building vertically.
For example:

``` markdown
# Horizontal Slide 1

## Vertical Slide 1

## Vertical Slide 2

# Horizontal Slide 2
```

With this layout horizontal navigation will proceed directly from
“Horizontal Slide 1” to “Horizontal Slide 2”, with vertical navigation
to “Vertical Slide 1”, etc. presented as an option on “Horizontal Slide
1”. Global reveal option
[`navigationMode`](https://revealjs.com/vertical-slides/#navigation-mode)
can be tweaked to change this behavior.

## Reveal Options

Reveal.js has many additional options to configure it’s behavior. You
can specify any of these options using `reveal_options`, for example:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    self_contained: false
    reveal_options:
      slideNumber: true
      previewLinks: true
---
```

You can find documentation on the various available Reveal.js options
here: <https://revealjs.com/config/>.

## Figure Options

There are a number of options that affect the output of figures within
reveal.js presentations:

- `fig_width` and `fig_height` can be used to control the default figure
  width and height (7x5 is used by default)

- `fig_retina` Specifies the scaling to perform for retina displays
  (defaults to 2, which currently works for all widely used retina
  displays). Note that this only takes effect if you are using knitr \>=
  1.5.21. Set to `null` to prevent retina scaling.

- `fig_caption` controls whether figures are rendered with captions

For example:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    fig_width: 7
    fig_height: 6
    fig_caption: true
---
```

## MathJax Equations

By default [MathJax](https://www.mathjax.org/) scripts are included in
reveal.js presentations for rendering LaTeX and MathML equations. You
can use the `mathjax` option to control how MathJax is included:

- Specify “default” to use an https URL from the official MathJax CDN.

- Specify “local” to use a local version of MathJax (which is copied
  into the output directory). Note that when using “local” you also need
  to set the `self_contained` option to false.

- Specify an alternate URL to load MathJax from another location.

- Specify null to exclude MathJax entirely.

For example, to use a local copy of MathJax:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    mathjax: local
    self_contained: false
---
```

To use a self-hosted copy of MathJax:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    mathjax: "https://example.com/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
---
```

To exclude MathJax entirely:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    mathjax: null
---
```

## Document Dependencies

By default R Markdown produces standalone HTML files with no external
dependencies, using data: URIs to incorporate the contents of linked
scripts, stylesheets, images, and videos. This means you can share or
publish the file just like you share Office documents or PDFs. If you’d
rather keep dependencies in external files you can specify
`self_contained: false`. For example:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    self_contained: false
---
```

Note that even for self contained documents MathJax is still loaded
externally (this is necessary because of it’s size). If you want to
serve MathJax locally then you should specify `mathjax: local` and
`self_contained: false`.

One common reason keep dependencies external is for serving R Markdown
documents from a website (external dependencies can be cached separately
by browsers leading to faster page load times). In the case of serving
multiple R Markdown documents you may also want to consolidate dependent
library files (e.g. Bootstrap, MathJax, etc.) into a single directory
shared by multiple documents. You can use the `lib_dir` option to do
this, for example:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    self_contained: false
    lib_dir: libs
---
```

## Reveal Plugins

You can enable various reveal.js plugins using the `reveal_plugins`
option. Plugins currently supported include:

| Plugin | Description |
|----|----|
| [notes](https://revealjs.com/speaker-view/) | Present per-slide notes in a separate browser window. Open Note view pressing `S`. |
| [zoom](https://lab.hakim.se/zoom-js/) | Zoom in and out of selected content with `Alt+Click.` |
| [search](https://github.com/hakimel/reveal.js/blob/master/plugin/search/search.js) | Find a text string anywhere in the slides and show the next occurrence to the user. Open search box using `CTRL + SHIFT + F`. |
| [chalkboard](https://github.com/rajgoel/reveal.js-plugins/tree/master/chalkboard) | Include handwritten notes within a presentation. Press `c` to write on slides, Press `b` to open a whiteboard or chalkboard to write. |
| [menu](https://github.com/denehyg/reveal.js-menu) | Include a navigation menu within a presentation. Press `m` to open the menu. |

Note that the use of plugins requires that the `self_contained` option
be set to false. For example, this presentation includes both the
“notes” and “search” plugins:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    self_contained: false
    reveal_plugins: ["notes", "search"]
---
```

You can specify additional options for the `chalkboard` and `menu`
plugins using `reveal_options`, for example:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    self_contained: false
    reveal_plugins: ["chalkboard", "menu"]
    reveal_options:
      chalkboard:
        theme: whiteboard
        toggleNotesButton: false
      menu:
        side: right
---
```

No other plugins can be added in `revealjs_presentation()`. You can open
feature request for new plugins or you would need to use a custom
template to write your own HTML format including custom plugins.

## Advanced Customization

### Includes

You can do more advanced customization of output by including additional
HTML content or by replacing the core pandoc template entirely. To
include content in the document header or before/after the document body
you use the `includes` option as follows:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    includes:
      in_header: header.html
      before_body: doc_prefix.html
      after_body: doc_suffix.html
---
```

### Pandoc Arguments

If there are pandoc features you want to use that lack equivalents in
the YAML options described above you can still use them by passing
custom `pandoc_args`. For example:

``` yaml
---
title: "Habits"
output:
  revealjs::revealjs_presentation:
    pandoc_args: [
      "--title-prefix", "Foo",
      "--id-prefix", "Bar"
    ]
---
```

Documentation on all available pandoc arguments can be found in the
[pandoc user guide](https://pandoc.org/MANUAL.html#options).

## Shared Options

If you want to specify a set of default options to be shared by multiple
documents within a directory you can include a file named `_output.yaml`
within the directory. Note that no YAML delimiters or enclosing output
object are used in this file. For example:

**\_output.yaml**

``` yaml
revealjs::revealjs_presentation:
  theme: sky
  transition: fade
  highlight: pygments
```

All documents located in the same directory as `_output.yaml` will
inherit it’s options. Options defined explicitly within documents will
override those specified in the shared options file.

## Code of Conduct

Please note that the revealjs project is released with a [Contributor
Code of
Conduct](https://pkgs.rstudio.com/revealjs/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
