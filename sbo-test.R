setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Business%20Owners/2007%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Business%20Owners/recode%20and%20replicate.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
dbDisconnect( db )
