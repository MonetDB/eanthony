setwd(Sys.getenv("RWD"))
path.to.7z <- "7za"
options( encoding = "windows-1252" )
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/download%20and%20import.R" , prompt = FALSE , echo = TRUE )
