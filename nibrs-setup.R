setwd(Sys.getenv("RWD"))
your.username <- 'some'
your.password <- 'thing'
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Incident-Based%20Reporting%20System/download%20all%20microdata.R" , prompt = FALSE, echo = TRUE)
