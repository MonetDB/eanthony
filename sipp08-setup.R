setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
if (.Platform$OS.type == 'windows') {
	setInternet2(FALSE)
}

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Income%20and%20Program%20Participation/2008%20panel%20-%20download%20and%20create%20database.R" , prompt = FALSE , echo = TRUE )

# corruption sniffing
db <- dbConnect( MonetDBLite() , paste0( getwd() , "/SIPP08" ) )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
dbDisconnect( db )
