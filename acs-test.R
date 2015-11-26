setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/acs.sh")
load( paste0(getwd(),'/acs2011_1yr.rda' ))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/replicate%20cms%20state%20counts.R" , prompt = FALSE , echo = TRUE )
