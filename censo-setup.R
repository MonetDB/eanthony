setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	setInternet2(FALSE)
} else {
	options(encoding="latin1")	
}
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Censo%20Demografico/download%20and%20import.R" , prompt = FALSE , echo = TRUE )
