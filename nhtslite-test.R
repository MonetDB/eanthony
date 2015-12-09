setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
load(paste0(getwd(), '/2009 designs.rda'))
downloader::source_url("https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/National%20Household%20Travel%20Survey/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
