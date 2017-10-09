
install.packages(c( "data.table" , "RSQLite" , "devtools" , "roxygen2" ) , repos="http://cran.rstudio.com/")

#update.packages( repos="http://cran.rstudio.com/" , ask = FALSE , quiet = TRUE , type = if ( .Platform$OS.type == 'windows' ) 'win.binary' else 'source' )

devtools::install_github( "gergness/srvyr" , dependencies = TRUE )
devtools::install_github( "djalmapessoa/convey" , dependencies = TRUE )
devtools::install_github( "ajdamico/lodown" , dependencies = TRUE)

install_submodule_git <- function(x, ...) {
  install_dir <- tempfile()
  system(paste("git clone --recursive --depth 1", shQuote(x), 
shQuote(install_dir)))
  devtools::install(install_dir, ...)
}
install_submodule_git("https://github.com/hannesmuehleisen/MonetDBLite-R")


