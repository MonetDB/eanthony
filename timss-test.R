setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Trends%20in%20International%20Mathematics%20and%20Science%20Study/replication.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Trends%20in%20International%20Mathematics%20and%20Science%20Study/analysis%20examples.R" , prompt = FALSE , echo = TRUE )


# corruption sniffing (not necessary for timss analysis runs)
# db <- dbConnect( MonetDBLite() , dbfolder )
# corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
# dbGetQuery( db , corruption_trigger )
