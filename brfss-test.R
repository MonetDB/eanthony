setwd(Sys.getenv("RWD"))

options(monetdb.debug.query=T)

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/replicate%20cdc%20weat%20-%202010.R" , prompt = FALSE , echo = TRUE )

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/2011%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0)
