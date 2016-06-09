setwd(Sys.getenv("RWD"))

if (.Platform$OS.type == 'windows') {
	path.to.winrar <- normalizePath( "C:/Program Files/winrar/winrar.exe" )		# # only windows users need this line
} else {
	options( encoding = "windows-1252" )
}

natality.sets.to.download <- 2014:1999
periodlinked.sets.to.download <- 2013:2001
cohortlinked.sets.to.download <- 2010:1995
mortality.sets.to.download <- 2014:2000
fetaldeath.sets.to.download <- 2013:2005
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite::MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
