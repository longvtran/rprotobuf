library(httr)
library(jsonlite)
library(RProtoBuf)

# USING JSON:
# call the doubler package multiple times through OCPU
# the mult doubler function takes in input x and k,
# and returns a value = (2 ^ x) * k
MultipleDouble <- function(x, k) {
  # on a separated window, start ocpu by using library(ocpu) and ocpu_start_server()
  # Note: the following url is the url of my package double, which take an integer
  # x and double it
  ocpu.url <- "http://localhost:5656/ocpu/library/doubler/R/double/json"
  result <- x
  for (i in 1: k){
    # use POST and get the result in JSON
    post.request <- POST(ocpu.url, body = list(x = result), encode = "json")
    result <- content(post.request)[[1]]
    # alternatively, we can write:
    # result <- fromJSON(rawToChar(post_request$content))
  }
  result
}

# USING PROTOBUF:
# call the doubler package multiple times through OCPU
# the mult doubler function takes in input x and k,
# and returns a value = (2 ^ x) * k

MultipleDoublePb <- function(x, k) {
  # on a separated window, start ocpu by using library(ocpu) and ocpu_start_server()
  # Note: the following url is the url of my package double, which take an integer
  # x and double it
  ocpu.url.pb <- "http://localhost:5656/ocpu/library/doubler/R/double/pb"
  result <- x
  for (i in 1: k){
    # use POST and unserialize the content
    post.request.pb <- POST(ocpu.url.pb, body = list(x = result))
    result <- unserialize_pb(content(post.request.pb))
    
  }
  result
}


# alternatively, we can also write:
AltMultipleDoublePb <- function(x, k) {
  # on a separated window, start ocpu by using library(ocpu) and ocpu_start_server()
  # Note: the following url is the url of my package double, which take an integer
  # x and double it
  ocpu.url.pb <- "http://localhost:5656/ocpu/library/doubler/R/double/pb"
  result <- x
  for (i in 1: k){
    args <- list(x = result)
    post.request.pb <- POST(ocpu.url.pb, body = args,
      content_type = "application/x-protobuf")
    result <- unserialize_pb(content(post.request.pb))
  }
  result
}