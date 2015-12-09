setwd(Sys.getenv("RWD"))
options( encoding = "windows-1252" )
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/replicate%20cms%20state%20counts.R" , prompt = FALSE , echo = TRUE )
