setwd(Sys.getenv("RWD"))

memory.limit(128000)

options(monetdb.debug.query=T)
if (.Platform$OS.type != 'windows') {
	path.to.7z <- "7za"
}
include_puerto_rico <- TRUE
single.year.datasets.to.download <- 2011:2014
three.year.datasets.to.download <- 2011:2013
five.year.datasets.to.download <- 2011:2014
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/American%20Community%20Survey/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
