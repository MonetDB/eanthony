install_or_upgrade_packages <- function(lp, ...) {
	np <- lp[!(lp %in% installed.packages()[,"Package"])]
	if(length(np)) install.packages(np, ...)
	update.packages(ask=F, oldPkgs=lp, ...)
}

install_or_upgrade_packages(c("data.table", "RSQLite" , "devtools" , "roxygen2", "srvyr", "DBI", "digest", "testthat", "vardpoor", "IC2", "dbplyr","RODBC"), repos='http://cran.rstudio.com/', quiet=F,dependencies=TRUE)

devtools::install_github("hannesmuehleisen/convey" , dependencies = TRUE)

devtools::install_github("hannesmuehleisen/lodown" , dependencies = TRUE)

install_submodule_git <- function(x, ...) {
  install_dir <- tempfile()
  system(paste("git clone --recursive --depth 1", shQuote(x), 
shQuote(install_dir)))
  devtools::install(install_dir, ...)
}
#install_submodule_git("https://github.com/hannesmuehleisen/MonetDBLite-R")

