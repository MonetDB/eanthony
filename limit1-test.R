setwd(Sys.getenv("RWD"))

library(DBI)
library(MonetDB.R)
library(MonetDBLite)

pnad.dbfolder <- paste0( getwd() , "/MonetDB" )

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite() , pnad.dbfolder )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )
