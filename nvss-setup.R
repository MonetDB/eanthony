setwd(Sys.getenv("RWD"))

if (.Platform$OS.type == 'windows') {
	path.to.winrar <- normalizePath( "C:/Program Files/winrar/winrar.exe" )		# # only windows users need this line
} else {
	options( encoding = "windows-1252" )
}

natality.sets.to.download <- 2014:1999
periodlinked.sets.to.download <- 2013:2001
cohortlinked.sets.to.download <- 2010:1995
mortality.sets.to.download <- 2014:2000
fetaldeath.sets.to.download <- 2013:2005
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )
