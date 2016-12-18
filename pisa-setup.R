setwd(Sys.getenv("RWD"))
if( .Platform$OS.type != 'windows' ) path.to.7z <- "7za"
years.to.download <- c( 2000 , 2003 , 2006 , 2009 , 2012 , 2015 )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Program%20for%20International%20Student%20Assessment/download%20import%20and%20design.R" , prompt = FALSE , echo = TRUE )


warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite::MonetDBLite() , dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
