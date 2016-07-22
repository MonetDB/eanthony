lp <- c("xml2","rvest","xlsx", "Hmisc", "R.utils", "RCurl", "RSQLite", "SAScii", "XML", "descr", "devtools", "digest", "downloader", "foreign", "gdata", "ggplot2", "httr", "lavaan.survey", "lme4", "mapproj", "maps", "memisc", "mitools", "plyr", "readr", "readxl", "reshape2", "sas7bdat", "sdcMicro", "sqldf", "stringr", "survey", "tools", "ff","ggplot2","scales","fields","mapproj","RColorBrewer","maptools","raster","rgeos","fields","mgcv","spatstat","rgdal","data.table","RODBC","testthat","knitr","IC2","vardpoor","roxygen2")
repos <- c("http://cran.rstudio.com/")
# only install if required
np <- lp[!(lp %in% installed.packages()[,"Package"])]
if(length(np)) install.packages(np,repos=repos)
# update if neccessary
update.packages(repos=repos, ask=F)
# special snowflakes
devtools::install_github( "djalmapessoa/convey" )
devtools::install_github( "hadley/haven" )
devtools::install_github( "hannesmuehleisen/MonetDBLite" )
