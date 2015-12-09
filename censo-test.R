setwd(Sys.getenv("RWD"))
if (.Platform$OS.type == 'windows') {
	options(monetdb.programpath.override=Sys.getenv("MONETDBINSTALLDIR"))
}
batfile <- paste0(getwd(),"/MonetDB/censo_demografico.sh")
load('pes 2010 design.rda')
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/Censo%20Demografico/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
