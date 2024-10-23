---
date: "2024-10-25"
title: "Web scraping Swedish fund flow data using R"
includeSubheader: true
tags: ["Finance", "R", "Web scraping"]
---

**Challenge 1: Learn how to extract data in Excel files from a website and read into R**


**Challenge 2: Track investor sentiment through fund flows**


The [**Swedish Investment Fund Association (Fondbolagens förening)**](https://www.fondbolagen.se/) provides valuable statistics on fund flows, including data on net purchases, redemptions, and total assets under management (AUM) across different types of funds in Sweden. Scraping data from their website gives you a rich dataset for financial analysis. My idea is to learn how to scrape this data from their webpage, clean it and visualise it. My aim is to leverage the data in order to track investor sentiment through the fund flows by: visualising how inflows and outflows into different fund types (equity, bond, money market) fluctuate in response to global market events, such interest rate changes.

Previously I have always downloaded files manually instead of scraping. Hence, he challange for me here is to learn how to scrape the Excel-files containing the data from the web using the following three steps:

1. Identify the URLs of the Excel Files: Extract the URLs of the downloadable Excel files from the webpage. These files are updated monthly, so automating the process saves time.

2. Download the Excel Files: Automate the download of the Excel files using R packages like [**rvest**](https://rvest.tidyverse.org/) (for scraping) and [**httr**](https://httr.r-lib.org/) (for handling HTTP requests).

3. Read and Process the Excel Files: Once the files are downloaded, I use [**readxl**](https://readxl.tidyverse.org/) to load the content of the Excel files into R for analysis.



# 1. Install necessary packages:





