load( "seer lp.rda" )

setwd(Sys.getenv("RWD"))

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Surveillance%20Epidemiology%20and%20End%20Results/download.R" , prompt = FALSE , echo = TRUE )

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Surveillance%20Epidemiology%20and%20End%20Results/import%20individual-level%20tables%20into%20monetdb.R" , prompt = FALSE , echo = TRUE )


# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
