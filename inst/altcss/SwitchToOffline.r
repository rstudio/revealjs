files<-list.files("css/theme/source",full.names = TRUE)
replacement_line<-"@import url(../../lib/font/fonts.css);"
for(f in files){
  scss<-readLines(f,warn = FALSE)
  onlinecss<-grep("@import url.https.*",
       scss)
  scss[onlinecss]<-replacement_line
  writeLines(scss, f)
}

# Fudge for npm gooffline bug
file<-"font/fonts.css"
ocss<-readLines(file,warn = FALSE)
eot<-grep("eot|svg", ocss)
ocss[eot]<-""
writeLines(ocss, file)