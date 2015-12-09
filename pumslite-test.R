setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/pums.sh")
load('pums_2000_5_m.rda')
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/United%20States%20Decennial%20Census%20Public%20Use%20Microdata%20Sample/2000%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )

