setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
years.to.download <- c( 1983 , 1990 , 1995 , 2001 , 2009 )
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Household%20Travel%20Survey/download%20and%20import.R" , prompt = FALSE , echo = TRUE)

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
