setwd(Sys.getenv("RWD"))
if (.Platform$OS.type != 'windows') options(encoding="windows-1252")
options(monetdb.debug.query=T)
options(monetdb.debug.control=T)
years.to.download <- 1984:2014
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE)

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
