setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url("https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/National%20Incident-Based%20Reporting%20System/reproduce%20fbi%20tables.R" , prompt = FALSE, echo = TRUE)
