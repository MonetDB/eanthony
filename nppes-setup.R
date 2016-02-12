setwd(Sys.getenv("RWD"))
path.to.7z <- "7za"
options(monetdb.debug.query=T)

options( encoding = "windows-1252" )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/download%20and%20import.R" , prompt = FALSE , echo = TRUE )


# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
