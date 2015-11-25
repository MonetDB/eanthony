setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/censo_demografico.sh")
load( paste0(getwd(),'/pes 2010 design.rda' ))
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/Censo%20Demografico/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
