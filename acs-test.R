setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/American%20Community%20Survey/replicate%20census%20estimates%20-%202011.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/American%20Community%20Survey/2011%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )
