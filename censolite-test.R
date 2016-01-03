setwd(Sys.getenv("RWD"))
options(monetdb.debug.query=T)

# record current time
start_time <- Sys.time()
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/censolite/Censo%20Demografico/analysis%20examples.R" , prompt = FALSE , echo = TRUE )
# how long did `analysis examples.R` take?
print( Sys.time() - start_time )


downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/censolite/Censo%20Demografico/variable%20recode%20example.R" , prompt = FALSE , echo = TRUE )
# how long did `variable recode example.R` take?
print( Sys.time() - start_time )
