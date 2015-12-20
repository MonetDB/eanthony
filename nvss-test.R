setwd(Sys.getenv("RWD"))
downloader::source_url( "https://raw.github.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/replicate%20cdc%20tabulations.R" , prompt = FALSE , echo = TRUE )
downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/National%20Vital%20Statistics%20System/replicate%20age-adjusted%20death%20rate.R" , prompt = FALSE , echo = TRUE )
