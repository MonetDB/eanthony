lp <- c("xlsx", "Hmisc", "R.utils", "RCurl", "RSQLite", "SAScii", "XML", "descr", "devtools", "digest", "downloader", "foreign", "gdata", "ggplot2", "haven", "httr", "lavaan.survey", "lme4", "mapproj", "maps", "memisc", "mitools", "plyr", "readr", "readxl", "reshape2", "sas7bdat", "sdcMicro", "sqldf", "sqlsurvey", "stringr", "survey", "tools", "ff")
repos <- c("http://cran.rstudio.com/", "http://R-Forge.R-project.org")
# only install if required
np <- lp[!(lp %in% installed.packages()[,"Package"])]
if(length(np)) install.packages(np,repos=repos)
# update if neccessary
update.packages(repos=repos, ask=F)
# special snowflakes
devtools::install_github("BioStatMatt/sas7bdat.parso")
install.packages(c("MonetDB.R", "MonetDBLite"), repos=c("http://dev.monetdb.org/Assets/R/", "http://cran.rstudio.com/"))
