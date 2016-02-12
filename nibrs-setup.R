setwd(Sys.getenv("RWD"))
your.username <- 'hannes@cwi.nl'
your.password <- 'cwicwi'
your.password <- 'fuuu'
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Incident-Based%20Reporting%20System/download%20all%20microdata.R" , prompt = FALSE, echo = TRUE)


# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
