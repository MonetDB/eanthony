setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/nvss.sh")
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/replicate%20cdc%20tabulations.R" , prompt = FALSE , echo = TRUE )
