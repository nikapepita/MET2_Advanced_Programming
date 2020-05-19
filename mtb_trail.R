###Aim: Get trails

# required packages for our client
library(httr)
library(xml2)

library(magrittr)
library(pbapply)
library(magick)
library(dplyr)

# base url
# denver, 39.740493, -104.990921

url <- "https://www.mtbproject.com/data/get-trails?lat=39.7404&lon=-104.9909&maxDistance=100&key=200763290-f861c2de662a12ce9b6a78f6946b30d5"

## Part 1: Extracting the products and API version by parsing the overview page's HTML

# check what we get back from there
reply <- GET(url)
http_status(reply)
reply <- GET(url) %>% content()

trails <- data.frame()

for (i in 1:length(reply$trails)){
  print(i)
  att1 <- as.data.frame(reply$trails[[i]]$name)
  att2 <- as.data.frame(reply$trails[[i]]$difficulty)
  att3 <- as.data.frame(reply$trails[[i]]$conditionStatus)
  trails1 <- cbind(att1,att2, att3)
  trails  <- rbind(trails ,trails1)
}

colnames(trails) <- c("name","difficulty","conditionsStatus")
trails
