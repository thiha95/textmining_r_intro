# General-purpose data wrangling
library(tidyverse)  

# Parsing of HTML/XML files  
library(rvest)    

# String manipulation
library(stringr)   

# Verbose regular expressions
library(rebus)     

# Eases DateTime manipulation
library(lubridate)

    # Total_title

total_title <- c()
for(i in 0:42)
{
  url0<-"https://www.mmtimes.com/search/node/Chinese%20investment%2C%20Myanmar"
  url<-paste(url0,"?page=",i,sep="")
  webpage <-read_html(url)
  total_title <-c(total_title,webpage
                  %>% html_nodes(".search-title a")
                  %>% html_text())
}

    # Total_date

total_date <- c()
for(i in 0:42)
{
  url0<-"https://www.mmtimes.com/search/node/Chinese%20investment%2C%20Myanmar"
  url<-paste(url0,"?page=",i,sep="")
  webpage <-read_html(url)
  total_date <-c(total_date,webpage
                  %>% html_nodes(".news-date")
                  %>% html_text())
}


    # Total_category

total_category <- c()
for(i in 0:42)
{
  url0<-"https://www.mmtimes.com/search/node/Chinese%20investment%2C%20Myanmar"
  url<-paste(url0,"?page=",i,sep="")
  webpage <-read_html(url)
  total_category <-c(total_category,webpage
                 %>% html_nodes(".news-category")
                 %>% html_text())
}

    # Total_article_link
total_article_link <- c()
for(i in 0:42)
{
  url0<-"https://www.mmtimes.com/search/node/Chinese%20investment%2C%20Myanmar"
  url<-paste(url0,"?page=",i,sep="")
  webpage <-read_html(url)
  total_article_link <-c(total_article_link,webpage
                     %>% html_nodes(".search-title a")
                     %>% html_attrs() 
                     %>% str_trim())
}
total_article_link <-unlist(total_article_link)
total_article_link <-gsub("href","",total_article_link )

  # Total_content

    ## Empty vector
total_content <- vector("list", length(total_article_link))

    ## For loop

base_url <- "https://www.mmtimes.com"

for(k in seq_along(total_article_link)) {
  true_url <- paste0(base_url, total_article_link[k])
  webpage <- read_html(true_url)
  content <- html_node(webpage, ".node-content")
  content_text <- html_text(content)
  
  # Put the text in the empty vector
  total_content[[k]] <- content_text
}

  #Data-Preprocessing of total_content
  total_content <-gsub("\n","",total_content)
  total_content <-gsub("\t","",total_content)
  # Trim additional white space
  total_content <- str_trim(total_content)
  total_content <- unlist(total_content) 

# Makeing a dataframe and save it

mmtimes_df<-data.frame(Title = total_title,
                       Date = total_date,
                       Category = total_category,
                       News_content = total_content,
                       News_link = total_article_link)

write.csv(mmtimes_df, file = "/Users/wangzhiwei/Downloads/Data Science/R/Text Mining Project/Data Preparation/mmtimes.csv")



