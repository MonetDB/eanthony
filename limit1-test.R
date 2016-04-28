setwd(Sys.getenv("RWD"))

pnad.dbfolder <- paste0( getwd() , "/MonetDB" )

# corruption sniffing
db <- dbConnect( MonetDBLite() , pnad.dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
