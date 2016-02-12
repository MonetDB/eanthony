setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Basic%20Stand%20Alone%20Medicare%20Claims%20Public%20Use%20Files/2008%20-%20download%20all%20csv%20files.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Basic%20Stand%20Alone%20Medicare%20Claims%20Public%20Use%20Files/2008%20-%20import%20all%20csv%20files%20into%20monetdb.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
