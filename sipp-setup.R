setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
if (.Platform$OS.type == 'windows') {
	setInternet2(FALSE)
}
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Income%20and%20Program%20Participation/1996%20panel%20-%20download%20and%20create%20database.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Income%20and%20Program%20Participation/2001%20panel%20-%20download%20and%20create%20database.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Income%20and%20Program%20Participation/2004%20panel%20-%20download%20and%20create%20database.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Survey%20of%20Income%20and%20Program%20Participation/2008%20panel%20-%20download%20and%20create%20database.R" , prompt = FALSE , echo = TRUE )
