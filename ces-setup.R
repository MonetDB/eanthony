setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Consumer%20Expenditure%20Survey/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing (not necessary for ce download script)
# db <- dbConnect( MonetDBLite() , dbfolder )
# corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
# dbGetQuery( db , corruption_trigger )
