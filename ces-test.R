setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Consumer%20Expenditure%20Survey/replicate%20integrated%20mean%20and%20se.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Consumer%20Expenditure%20Survey/2011%20fmly%20intrvw%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
