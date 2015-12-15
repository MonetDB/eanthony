setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)

options( encoding = "windows-1252" )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/replicate%20cms%20state%20counts.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/merge%20taxonomy%20ids.R" , prompt = FALSE , echo = TRUE )
