setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/censolite/Censo%20Demografico/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/censolite/Censo%20Demografico/variable%20recode%20example.R" , prompt = FALSE , echo = TRUE )
