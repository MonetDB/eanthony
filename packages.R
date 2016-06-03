lp <- c("xml2","rvest","xlsx", "Hmisc", "R.utils", "RCurl", "RSQLite", "SAScii", "XML", "descr", "devtools", "digest", "downloader", "foreign", "gdata", "ggplot2", "haven", "httr", "lavaan.survey", "lme4", "mapproj", "maps", "memisc", "mitools", "plyr", "readr", "readxl", "reshape2", "sas7bdat", "sdcMicro", "sqldf", "stringr", "survey", "tools", "ff","ggplot2","scales","fields","mapproj","RColorBrewer","maptools","raster","rgeos","fields","mgcv","spatstat","rgdal","data.table")
repos <- c("http://cran.rstudio.com/")
# only install if required
np <- lp[!(lp %in% installed.packages()[,"Package"])]
if(length(np)) install.packages(np,repos=repos)
# update if neccessary
update.packages(repos=repos, ask=F)
# special snowflakes
devtools::install_github("hannesmuehleisen/dummy-MonetDB.R")
devtools::install_github( "hannesmuehleisen/MonetDBLite" )
# this sometimes breaks
devtools::install_github("BioStatMatt/sas7bdat.parso")
# my bugfriend's back and he's gonna be trouble.  hey now, hey now, my bugfriend's back.
devtools::install_github( "djalmapessoa/convey" )
