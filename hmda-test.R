setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)
downloader::source_url("https://raw.github.com/ajdamico/asdfree/master/Home%20Mortgage%20Disclosure%20Act/replicate%20ffiec%20publications.R" , prompt = FALSE , echo = TRUE )
