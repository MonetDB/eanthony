setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Consumer%20Expenditure%20Survey/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )

warnings()
