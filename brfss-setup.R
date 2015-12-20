setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	setInternet2(FALSE)
} else {
	options(encoding="windows-1252")
}
options(monetdb.debug.query=T)
options(monetdb.debug.control=T)
years.to.download <- 1984:2014
downloader::source_url("https://raw.github.com/ajdamico/asdfree/master/Behavioral%20Risk%20Factor%20Surveillance%20System/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE)
