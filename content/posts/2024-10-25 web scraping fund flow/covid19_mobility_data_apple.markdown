---
date: "2024-10-25"
title: "Web scraping fund flow"
includeSubheader: true
tags: ["COVID-19", "R", "Mobility"]
---

**Challenge 1: Learn to use basic data visualisation with tidyverse**


**Challenge 2: Get to know Apple's COVID-19 mobility trend data**

During 2020 several new R-packages providing data relating to the global pandemic COVID-19 were released. One of these is [**Apple's**](https://covid19.apple.com/mobility) mobility trend data, which the tech-giant released to the public in March 2020. (Shortly after [**Google**](https://www.google.com/covid19/mobility/) also released their mobility trend data which I will dive into in an upcoming post).

Most of my previous coding experience was mostly performed in order to wrangle data or use statistical methods to arrive to a numeric result that I would export to a csv-file that in turn would serve as an input to another program. Hence, my expereince of visualising data for presentations or reports is close to non-existent. The biggest challenge for me in this post is to learn to visualize data using [**RMarkdown**](https://rmarkdown.rstudio.com/) and the package [**tidyverse**](https://www.tidyverse.org/).


The mobility trend data from both Apple and Google is available in the R [**covid19mobility**](https://github.com/Covid19R/covid19mobility) package. Apple's data is published daily and "reflects requests for directions in Apple Maps" since 13 January 2020 for countries, cities and subregions.