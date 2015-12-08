setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	batfile <- paste0(getwd(),"/MonetDB/hmda.bat")
} else {
	batfile <- paste0(getwd(),"/MonetDB/hmda.sh")
}
options(monetdb.debug.query=T)
downloader::source_url("https://raw.github.com/ajdamico/asdfree/master/Home%20Mortgage%20Disclosure%20Act/replicate%20ffiec%20publications.R" , prompt = FALSE , echo = TRUE )
