setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/Survey%20of%20Business%20Owners/2007%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/Survey%20of%20Business%20Owners/recode%20and%20replicate.R" , prompt = FALSE , echo = TRUE )
