setwd(Sys.getenv("RWD"))
cps.years.to.download <- c( 2015 , 2014 , 2014.58 , 2014.38 , 2013:1998 )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Current%20Population%20Survey/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )
