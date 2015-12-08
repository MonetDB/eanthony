setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	options(monetdb.programpath.override=Sys.getenv("MONETDBINSTALLDIR"))
} else {
	path.to.7z <- "7za"
}
options(monetdb.debug.query=T)
years.to.download <- 2014:2006
downloader::source_url("https://raw.github.com/ajdamico/asdfree/master/Home%20Mortgage%20Disclosure%20Act/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE)
