setwd(Sys.getenv("RWD"))

options(monetdb.debug.query=T)

downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/replicate%20cdc%20weat%20-%202010.R" , prompt = FALSE , echo = TRUE )

downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/2011%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )
