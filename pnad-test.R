setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
options( encoding = "windows-1252" )		# # only macintosh and *nix users need this line
year.to.analyze <- 2012
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/replicate%20IBGE%20estimates%20-%202011.R" , prompt = FALSE , echo = TRUE )


# corruption sniffing
db <- dbConnect( MonetDBLite() , pnad.dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
dbDisconnect( db )
