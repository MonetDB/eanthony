setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)

if (.Platform$OS.type == 'windows') {
	setInternet2( FALSE )						# # only windows users need this line
} else {
	options( encoding = "windows-1252" )		# # only macintosh and *nix users need this line
}

years.to.download <- c( 2001:2009 , 2011:2014 )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/pnad.survey.R" , prompt = FALSE , echo = TRUE )
