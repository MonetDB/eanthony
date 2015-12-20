setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
if (.Platform$OS.type == 'windows') {
	batfile <- paste0(getwd(),"/MonetDB/bsapuf.bat")
} else {
	batfile <- paste0(getwd(),"/MonetDB/bsapuf.sh")
}

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Basic%20Stand%20Alone%20Medicare%20Claims%20Public%20Use%20Files/2008%20-%20replicate%20cms%20publications.R" , prompt = FALSE , echo = TRUE )
