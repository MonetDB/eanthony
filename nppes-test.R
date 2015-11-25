setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/nppes.sh")
options( encoding = "windows-1252" )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/replicate%20cms%20state%20counts.R" , prompt = FALSE , echo = TRUE )
