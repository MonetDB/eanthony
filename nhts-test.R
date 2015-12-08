setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	batfile <- paste0(getwd(),"/MonetDB/nhts.bat")
} else {
	batfile <- paste0(getwd(),"/MonetDB/nhts.sh")
}
options(monetdb.debug.query=T)
load(paste0(getwd(), '/2009 designs.rda'))
downloader::source_url("https://raw.github.com/ajdamico/asdfree/master/National%20Household%20Travel%20Survey/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
