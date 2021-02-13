install.packages('blogdown')
library(blogdown)
setwd("/Users/ruzicagajic/Documents/Data Scientist/r-website/r-website/content/post/2021-02-05 COVID-19 mobility trends by Apple")


if (!require("rmarkdown"))
install.packages("rmarkdown")


if (!require("pacman"))
install.packages("pacman")

blogdown::hugo_version()
blogdown::update_hugo()

blogdown::stop_server()
blogdown::serve_site()

