setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Household%20Travel%20Survey/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Household%20Travel%20Survey/replicate%20ornl.R" , prompt = FALSE , echo = TRUE )
