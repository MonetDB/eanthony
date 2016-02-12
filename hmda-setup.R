setwd(Sys.getenv("RWD"))
if (.Platform$OS.type != 'windows') {
	path.to.7z <- "7za"
}
options(monetdb.debug.query=T)
years.to.download <- 2014:2006
downloader::source_url("https://raw.githubusercontent.com/ajdamico/asdfree/master/Home%20Mortgage%20Disclosure%20Act/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE)

# corruption sniffing
db <- dbConnect( MonetDBLite() , dbfolder )
corruption_trigger <- "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null"
dbGetQuery( db , corruption_trigger )
