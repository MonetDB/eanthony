setwd(Sys.getenv("RWD"))
batfile <- paste0(getwd(),"/MonetDB/pisa.sh")
load('2012 int_stu12_dec03.rda')
downloader::source_url( "https://raw.githubusercontent.com/hannesmuehleisen/asdfree/master/Program%20for%20International%20Student%20Assessment/analysis%20examples.R" , prompt = FALSE , echo = TRUE )

