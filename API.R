
library(xml2) #more modern package
library(httr)
library(magrittr)
library(pbapply)
library(magick)

# base url
url_api <- "https://api.met.no/weatherapi"

# check what we get back from there

reply <- httr::GET(url_api)

#respond status
http_status(reply)

#extract info from body
reply_content <- content(reply)
reply_content # right now we just contacted a website
class(reply_content)
view(reply_content)

#crawl for table
xml_find_all(reply_content,"//table")  #encode a string and search xml doc.
xml_prod <- xml_find_first(reply_content,"//table")  #encode a string and search xml doc.

#extract head of the table
prod_head <- xml_children(xml_prod)[[1]]%>%
  xml_contents()%>%
  xml_children()%>%
  xml_text()

# second version - not so nice
#xml_text(xml_children(xml_contents(xml_children(xml_prod)[[1]])))

#extract the body of the table
products_body <- xml_children(xml_prod)[[2]]%>%
  xml_children() %>%
  
  lapply(function(x){
    x <- xml_contents(x)
    xml_text(x)[seq(1,length(x),by=2)]
  })

#transfer list in dataframe
products <- do.call(rbind.data.frame, products_body)
colnames(products) <- prod_head

view(products)

#API call
