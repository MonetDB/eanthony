setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
if (.Platform$OS.type != 'windows') {
	path.to.7z <- "7za"
}
single.year.datasets.to.download <- 2005:2014
three.year.datasets.to.download <- 2007:2013
five.year.datasets.to.download <- 2009:2013
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/American%20Community%20Survey/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/National%20Plan%20and%20Provider%20Enumeration%20System/download%20and%20import.R" , prompt = FALSE , echo = TRUE )
