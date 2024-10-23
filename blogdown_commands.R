
if (!require("rmarkdown"))
install.packages("rmarkdown")

if (!require("pacman"))
install.packages("pacman")

library(blogdown)
setwd("/Users/ruzicagajic/Documents/Data Scientist/r-website/r-website")
# setwd("/Users/ruzicagajic/Documents/Data Scientist/r-website/r-website/content/post/2021-02-05 COVID-19 mobility trends by Apple")

blogdown::hugo_version()
blogdown::install_hugo()
# blogdown::update_hugo()

blogdown::stop_server()
blogdown::serve_site()

