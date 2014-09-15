### R Markdown Format for reveal.js Presentations

This repository provides an [R Markdown](http://rmarkdown.rstudio.com) custom format for [reveal.js](http://lab.hakim.se/reveal-js/#/) HTML presentations.

#### Usage

To use this format you should install this package along with a recent (>= 0.3.2) version of the **rmarkdown** package:

```S
library(devtools)
install_github(c("rstudio/rmarkdown", "jjallaire/revealjs"))
```

You can then use the format within an R Markdown document as follows:

    ---
    title: "My Presentation"
    output:
      revealjs::revealjs_presentation
    ---
    
    
    
