setwd(Sys.getenv("RWD"))
load('pums_2000_5_m.rda')
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/United%20States%20Decennial%20Census%20Public%20Use%20Microdata%20Sample/2000%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/United%20States%20Decennial%20Census%20Public%20Use%20Microdata%20Sample/replicate%20control%20counts%20table.R" , prompt = FALSE , echo = TRUE )


