setwd(Sys.getenv("RWD"))

if (.Platform$OS.type != 'windows') {
	path.to.7z <- "7za"
}

downloader::source_url( "https://raw.githubusercontent.com/davidbrae/swmap/master/how%20to%20map%20the%20american%20community%20survey.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
