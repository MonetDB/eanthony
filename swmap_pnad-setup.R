setwd(Sys.getenv("RWD"))

memory.limit(64000)

if (.Platform$OS.type != 'windows') options( encoding = "windows-1252" )		# # only macintosh and *nix users need this line


downloader::source_url( "https://raw.githubusercontent.com/davidbrae/swmap/master/how%20to%20map%20the%20pesquisa%20nacional%20por%20amostra%20de%20domicilios.R" , prompt = FALSE , echo = TRUE )

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , pnad.dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
