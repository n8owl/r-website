---
date: "2021-02-05"
title: "COVID-19 mobility trends by Apple"
includeSubheader: true
tags: ["COVID-19", "R", "Mobility"]
---

**Challenge 1: Learn to use basic data visualisation with tidyverse**


**Challenge 2: Get to know Apple's COVID-19 mobility trend data**

During 2020 several new R-packages providing data relating to the global pandemic COVID-19 were released. One of these is [**Apple's**](https://covid19.apple.com/mobility) mobility trend data, which the tech-giant released to the public in March 2020. (Shortly after [**Google**](https://www.google.com/covid19/mobility/) also released their mobility trend data which I will dive into in an upcoming post).

Most of my previous coding experience was mostly performed in order to wrangle data or use statistical methods to arrive to a numeric result that I would export to a csv-file that in turn would serve as an input to another program. Hence, my expereince of visualising data for presentations or reports is close to non-existent. The biggest challenge for me in this post is to learn to visualize data using [**RMarkdown**](https://rmarkdown.rstudio.com/) and the package [**tidyverse**](https://www.tidyverse.org/).





The mobility trend data from both Apple and Google is available in the R [**covid19mobility**](https://github.com/Covid19R/covid19mobility) package. Apple's data is published daily and "reflects requests for directions in Apple Maps" since 13 January 2020 for countries, cities and subregions.

I start by loading the data:



{{<highlight r>}}
# Load Apple's country and city data and add it to a data frame
df_apple_country <- refresh_covid19mobility_apple_country()
df_apple_city <- refresh_covid19mobility_apple_city()

# Use the code below to load Apple's mobilty trend data for subregions of countries to a data frame
# I will be using the data on subregions in a future post.
# df_apple_subregion <- refresh_covid19mobility_apple_subregion()
{{</highlight>}}

Then I assign values to variables in order to faciitate the process of altering the city or country of interest:


```r
# Assign the country/city/region you are interested in to variables
country <- "Sweden"
countries <- c(country, "Norway", "Denmark")
cities <- c("Stockholm", "Oslo", "Copenhagen")

# Assign the start and end date of the data to variables for use in captions
start <- as.Date(min(df_apple_country$date))
end <- as.Date(max(df_apple_country$date))
```

Next, I create a custom theme for all text that I include in my plots:


```r
my_text_theme <- theme(
  plot.title = element_text(family = "Helvetica", face = "bold", size = (15)),
  plot.subtitle = element_text(family = "Helvetica", size = (10)),
  legend.position = "top",
  legend.title = element_blank(),
  legend.text = element_text(family = "Helvetica", colour="black", size = (10)),
  axis.text = element_text(family = "Helvetica", colour = "black", size = (10)))

theme_set(my_text_theme)
```

The data is very easy to use. 

1. I start by filtering out the mobility trend data for the country Sweden. 
2. Then I add a mobility indicator based on the string variable 'data_type'.
3. I sort the data by the new variable 'mobility_indicator'.
4. Finally, I visualise Apple's three mobility trend indicators (driving, public transport and walking) for Sweden in a plot.

I notice quite a big increase in driving during the summer months:


```r
plot1 <- df_apple_country %>%
  filter(location %in% country) %>%
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")
    ) %>%
  arrange(mobility_indicator) %>%
  
  ggplot(aes(x = date, y = (value/100-1)*100, color = mobility_indicator)) +
  geom_line() +
  theme_bw() +
  my_text_theme +
  
  scale_x_date(expand = c(0,0), labels = scales::date_format("%d %b %Y")) +
  scale_y_continuous(expand = c(0,0)) +
  scale_color_manual(values=c("#003f5c", "#bc5090", "#ffa600")) +
 
  labs(
    title = paste("Apple's mobility index for", country),
    subtitle = paste("Percentage change in routing requests since", as.character(start, "%d %B %Y")),
    caption = "Source: Apple, https://covid19.apple.com/mobility",
    x = "",
    y = ""
  )

plot1
```

<img src="/blog/2021-02-05 COVID-19 mobility trends by Apple/covid19_mobility_data_apple_files/figure-html/unnamed-chunk-4-1.png" width="672" />
I found the following page on the website [**www.learnui.design**](https://learnui.design/tools/data-color-picker.html#palette) very useful when searching for colours to use in the plots (that both work well with color-blindness and look good in both light and dark theme).

Next, I want to compare the mobility indicators for Sweden to those of neighboring Denmark and Norway. I use facetting in order to visualise the individual plots for each country stacked on top of one another:


```r
plot2 <- df_apple_country %>%
  filter(location %in% countries) %>%   # filter using the list of countries
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")
    ) %>%
  arrange(mobility_indicator) %>%
  
  ggplot(aes(x = date, y = (value/100 -1)*100, color = mobility_indicator)) +
  geom_line() +
  theme_bw() +
  my_text_theme +
  
  scale_x_date(expand = c(0,0), labels = scales::date_format("%b %y")) +
  scale_y_continuous(expand = c(0,0)) +
  scale_color_manual(values=c("#003f5c", "#bc5090", "#ffa600")) +

  labs(
    title = paste("Comparing Apple's mobility index for", countries[1], "to other countries"),
    subtitle = paste("Percentage change in routing requests since", as.character(start, "%d %B %Y")),
    caption = "Source: Apple, https://covid19.apple.com/mobility",
    x = "",
    y = ""
  ) + 
  
  facet_grid(rows = vars(location)) + # facet by rows
  theme(strip.placement = "outside")

plot2
```

<img src="/blog/2021-02-05 COVID-19 mobility trends by Apple/covid19_mobility_data_apple_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Next, instead of comparing three plots for each country, I want to compare three plots for each mobility indicator. I facet by columns (instead of by rows as above):


```r
plot3 <- df_apple_country %>%
  filter(location %in% countries) %>%
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")
    ) %>%
  arrange(mobility_indicator) %>%
  
  ggplot(aes(x = date, y = (value/100 -1)*100, color = location)) +  # I change the color aesthetic to 'location'
  geom_line() +
  theme_bw() +
  my_text_theme +
  
  scale_x_date(expand = c(0,0), labels = scales::date_format("%b %y")) +
  scale_y_continuous(expand = c(0,0)) +
  scale_color_manual(values=c("#003f5c", "#bc5090", "#ffa600")) +

  labs(
    title = paste("Comparing Apple's mobility index for", countries[1], "to other countries"),
    subtitle = paste("Percentage change in routing requests since", as.character(start, "%d %B %Y")),
    caption = "Source: Apple, https://covid19.apple.com/mobility",
    x = "",
    y = ""
  ) + 
  
  facet_grid(cols = vars(mobility_indicator)) + # facet by columns
  theme(strip.placement = "outside")

plot3
```

<img src="/blog/2021-02-05 COVID-19 mobility trends by Apple/covid19_mobility_data_apple_files/figure-html/unnamed-chunk-6-1.png" width="672" />

Next, I am curious to see whether the big uptick in driving during the summer of 2020 in Sweden was concentrated to Sweden's capital Stockholm. Instead of using the same aesthetics as for the plot with data for Sweden, I play around a bit. Turns out there was no increase of driving in the Swedish capital during the summer:


```r
plot4 <- df_apple_city %>%
  filter(location %in% cities[1]) %>%   # filter using the first city in the list 'cities'
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")
    ) %>%
  arrange(mobility_indicator) %>%
  
  ggplot(aes(x = date, y = (value/100-1)*100, color = mobility_indicator)) +
  geom_line() +
  theme_grey() +   # trying another theme
  my_text_theme +
  
  scale_x_date(expand = c(0,0), labels = scales::date_format("%d %b %Y")) +
  scale_y_continuous(expand = c(0,0)) +
  scale_color_viridis_d(option = "D") +   # trying another color, 5 options A - E are available
  
  labs(
    title = paste("Apple's mobility index for", cities[1]),
    subtitle = paste("Percentage change in routing requests since", as.character(start, "%d %B %Y")),
    caption = "Source: Apple, https://covid19.apple.com/mobility",
    x = "",
    y = ""
  )

plot4
```

<img src="/blog/2021-02-05 COVID-19 mobility trends by Apple/covid19_mobility_data_apple_files/figure-html/unnamed-chunk-7-1.png" width="672" />
I recommend that you check out the documentation of the package ggplot2 included in tidyverse, particularly the 'Scales' and 'Aesthetics' sections on the webpage [**www.ggplot2.tidyverse.org/**](https://ggplot2.tidyverse.org/reference/). ggplot2 is a system for declaratively creating graphics, based on [**The Grammar of Graphics**](http://vita.had.co.nz/papers/layered-grammar.pdf).

Next, I want to compare the mobility trend indicators for Sweden to the three biggest cities in the country: 1. Stockholm, 2. Gothenburg and 3. Malmö. Oddly, the city Malmö is spelled using the Swedish letter "ö" in the Apple data, while Gothenburg (in Swedish: Göteborg) is spelled in English "Gothenburg". Interesting, I wonder why that is? I also notice that there is no up swing in the mobility indicator 'driving' for any of the three cities, indicating that the big uptick in driving was performed outside the three biggest cities:


```r
sweden_cities <- c("Sweden", "Stockholm", "Gothenburg", "Malmö")

join_country <- df_apple_country %>%
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")) %>%
  select(1:7, mobility_indicator) %>%
  arrange(mobility_indicator)

join_city <- df_apple_city %>%
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")) %>%
  select(1:7, mobility_indicator) %>%
  arrange(mobility_indicator)

joined_country_city <- rbind(join_country, join_city)

# To change plot order of facet wrap, change the order of varible levels with factor()
joined_country_city$location <- factor(joined_country_city$location, levels = sweden_cities)

# Create facet wrap first with "old" order
plot5 <- joined_country_city %>%
  filter(location %in% sweden_cities) %>%
  ggplot(aes(x = date, y = (value/100 -1)*100, color = mobility_indicator)) +
  geom_line() +
  theme_bw() +
  my_text_theme +
  
  scale_x_date(expand = c(0,0), labels = scales::date_format("%b %y")) +
  scale_y_continuous(expand = c(0,0)) +
  scale_color_manual(values=c("#003f5c", "#bc5090", "#ffa600")) +

  labs(
    title = paste("Comparing Apple's mobility index for", sweden_cities[1], "and it's cities"),
    subtitle = paste("Percentage change in routing requests since", as.character(start, "%d %B %Y")),
    caption = "Source: Apple, https://covid19.apple.com/mobility",
    x = "",
    y = ""
  ) + 

  facet_wrap(facets = vars(location))
  
# Add new order to facet wrap
plot5 + facet_wrap(~ location)
```

<img src="/blog/2021-02-05 COVID-19 mobility trends by Apple/covid19_mobility_data_apple_files/figure-html/unnamed-chunk-8-1.png" width="672" />

Next, I want to compare Stockholm to the capitals of Denmark (Copenhagen) and Norway (Oslo). I want to visualise both all three capitals and countries in one single plot:


```r
capital_and_country <- c("Stockholm", "Copenhagen", "Oslo", "Sweden", "Denmark", "Norway")

join_country <- df_apple_country %>%
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")) %>%
  select(1:7, mobility_indicator) %>%
  arrange(mobility_indicator)

join_city <- df_apple_city %>%
  mutate(mobility_indicator = case_when(
    str_detect(data_type, "driving") ~ "Driving",
    str_detect(data_type, "transit") ~ "Public transport",
    str_detect(data_type, "walking") ~ "Walking")) %>%
  select(1:7, mobility_indicator) %>%
  arrange(mobility_indicator)

joined_country_city <- rbind(join_country, join_city)

# To change plot order of facet wrap, change the order of varible levels with factor()
joined_country_city$location <- factor(joined_country_city$location, levels = capital_and_country)

# Create facet wrap first with "old" order
plot6 <- joined_country_city %>%
  filter(location %in% capital_and_country) %>%
  ggplot(aes(x = date, y = (value/100 -1)*100, color = mobility_indicator)) +
  geom_line() +
  theme_bw() +
  my_text_theme +
  
  scale_x_date(expand = c(0,0), labels = scales::date_format("%b %y")) +
  scale_y_continuous(expand = c(0,0)) +
  scale_color_manual(values=c("#003f5c", "#bc5090", "#ffa600")) +

  labs(
    title = paste("Comparing Apple's mobility index for some countries and capitals"),
    subtitle = paste("Percentage change in routing requests since", as.character(start, "%d %B %Y")),
    caption = "Source: Apple, https://covid19.apple.com/mobility",
    x = "",
    y = ""
  ) + 

  facet_wrap(facets = vars(location))
  
# Add new order to facet wrap
plot6 + facet_wrap(~ location) 
```

<img src="/blog/2021-02-05 COVID-19 mobility trends by Apple/covid19_mobility_data_apple_files/figure-html/unnamed-chunk-9-1.png" width="672" />

That was all for now! Omg, there were so many more possibilities available for tweaking plots when using ggplot2 in tidyverse than I expected. I really had to spend quite some time online reading documentation and checking examples. The possibilites are truely immense so please see the examples above as a glimpse into the world of tidy! I can warmly recommend the folowing page on the website [**www.datacarpentry.org**](https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2) that I found particularly useful.
