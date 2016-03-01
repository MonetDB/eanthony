load( "nacjd login.rda" )

setwd(Sys.getenv("RWD"))

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Crime%20Victimization%20Survey/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )


# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
