setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/timsslite/Trends%20in%20International%20Mathematics%20and%20Science%20Study/download%20and%20import.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/timsslite/Trends%20in%20International%20Mathematics%20and%20Science%20Study/construct%20designs.R" , prompt = FALSE , echo = TRUE )
