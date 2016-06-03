setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/replicate%20cdc%20tabulations.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/replicate%20age-adjusted%20death%20rate.R" , prompt = FALSE , echo = TRUE )

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
