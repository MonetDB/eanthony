setwd(Sys.getenv("RWD"))

if (.Platform$OS.type == 'windows') {
	setInternet2( FALSE )						# # only windows users need this line
} else {
	options( encoding = "windows-1252" )		# # only macintosh and *nix users need this line
}

downloader::source_url( "https://raw.githubusercontent.com/davidbrae/swmap/master/how%20to%20map%20the%20pesquisa%20nacional%20por%20amostra%20de%20domicilios.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
