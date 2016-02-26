setwd(Sys.getenv("RWD"))

options(warn=2)

library(MonetDB.R)
library(MonetDBLite)


dbfolder <- paste0( getwd() , "/space MonetDB" )
db <- dbConnect( MonetDBLite() , dbfolder )



# https://www.monetdb.org/bugzilla/show_bug.cgi?id=3925
dbGetQuery( db , "SELECT NULL AS col1" )
dbWriteTable( db , 'mtcars' , mtcars )
dbGetQuery( db , "SELECT NULL AS col1 , mpg AS col2 FROM mtcars" )
dbGetQuery( db , "SELECT NULL * 7 AS col1" )





# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
