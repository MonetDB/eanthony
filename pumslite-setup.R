setwd(Sys.getenv("RWD"))
options(encoding="windows-1252")
one.percent.files.to.download <- c( 1990 , 2000 )
five.percent.files.to.download <- c( 1990 , 2000 )
ten.percent.files.to.download <- 2010
exclude.puerto.rico <- TRUE
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/United%20States%20Decennial%20Census%20Public%20Use%20Microdata%20Sample/download%20and%20import.R" , prompt = FALSE , echo = TRUE )

