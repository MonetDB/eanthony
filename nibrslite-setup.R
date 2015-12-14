setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
your.username <- 'hannes@cwi.nl'
your.password <- 'cwicwi'
downloader::source_url("https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/National%20Incident-Based%20Reporting%20System/download%20all%20microdata.R" , prompt = FALSE, echo = TRUE)
