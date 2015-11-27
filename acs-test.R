setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
if (.Platform$OS.type == 'windows') {
	batfile <- paste0(getwd(),"/MonetDB/acs.bat")
}
else {
	batfile <- paste0(getwd(),"/MonetDB/acs.sh")
}
load( paste0(getwd(),'/acs2011_1yr.rda' ))
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/American%20Community%20Survey/replicate%20census%20estimates%20-%202011.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/American%20Community%20Survey/2011%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )
