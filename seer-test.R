setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/seer.sh")
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/Surveillance%20Epidemiology%20and%20End%20Results/replicate%20case%20counts%20table.R" , prompt = FALSE , echo = TRUE )
