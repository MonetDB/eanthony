setwd(Sys.getenv("RWD"))
options(encoding="windows-1252")
years.to.download <- c( 2000 , 2003 , 2006 , 2009 , 2012 )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Program%20for%20International%20Student%20Assessment/download%20import%20and%20design.R" , prompt = FALSE , echo = TRUE )


# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
