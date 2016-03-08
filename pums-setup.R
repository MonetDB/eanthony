setwd(Sys.getenv("RWD"))

# temporary addition to have brfss re-download everything
if( Sys.Date() < "2016-03-12" ){

	options( "download_cached.usecache" = FALSE )
	options( "download_cached.savecache" = TRUE )

}


options(encoding="windows-1252")
one.percent.files.to.download <- c( 1990 , 2000 )
five.percent.files.to.download <- c( 1990 , 2000 )
ten.percent.files.to.download <- 2010
exclude.puerto.rico <- TRUE
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/United%20States%20Decennial%20Census%20Public%20Use%20Microdata%20Sample/download%20and%20import.R" , prompt = FALSE , echo = TRUE )



# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
dbDisconnect( db )
