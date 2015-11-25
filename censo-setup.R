setwd(Sys.getenv("RWD"))
options( encoding = "latin1" )	
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/Censo%20Demografico/download%20and%20import.R" , prompt = FALSE , echo = TRUE )
