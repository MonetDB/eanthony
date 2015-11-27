setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	batfile <- paste0(getwd(),"/MonetDB/brfss.bat")
}
else {
	batfile <- paste0(getwd(),"/MonetDB/brfss.sh")
}
options(monetdb.debug.query=T)
load(paste0(getwd(), '/b2011 design.rda'))
downloader::source_url("https://raw.github.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/2011%20single-year%20-%20analysis%20examples.R" , prompt = FALSE , echo = TRUE )


