setwd(Sys.getenv("RWD"))

if (.Platform$OS.type == 'windows') {
	setInternet2(FALSE)
} else {
	options(encoding="latin1")	
}

years.to.download <- c( 2000 , 2010 )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Censo%20Demografico/download%20and%20import.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
