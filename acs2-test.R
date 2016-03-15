setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/American%20Community%20Survey/replicate%20census%20estimates%20-%202011.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/American%20Community%20Survey/2011%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
