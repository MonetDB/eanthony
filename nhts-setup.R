
# temporary addition to have nhts re-download everything
if( Sys.Date() < "2016-03-18" ){

	options( "download_cached.usecache" = FALSE )
	options( "download_cached.savecache" = TRUE )

}

setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
years.to.download <- c( 1983 , 1990 , 1995 , 2001 , 2009 )
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Household%20Travel%20Survey/download%20and%20import.R" , prompt = FALSE , echo = TRUE)

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
