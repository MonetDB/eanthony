setwd(Sys.getenv("RWD"))

library(DBI)			# load the DBI package (implements the R-database coding)
library(MonetDB.R)
library(MonetDBLite)

options(warn=2)

dbfolder <- paste0( getwd() , "/space MonetDB" )
db <- dbConnect( MonetDBLite() , dbfolder )


# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
