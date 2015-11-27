setwd(Sys.getenv("RWD"))
downloader::source_url( "https://github.com/hannesmuehleisen/asdfree/blob/master/Basic%20Stand%20Alone%20Medicare%20Claims%20Public%20Use%20Files/2008%20-%20download%20all%20csv%20files.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://github.com/hannesmuehleisen/asdfree/blob/master/Basic%20Stand%20Alone%20Medicare%20Claims%20Public%20Use%20Files/2008%20-%20import%20all%20csv%20files%20into%20monetdb.R" , prompt = FALSE , echo = TRUE )
