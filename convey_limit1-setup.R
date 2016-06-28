setwd(Sys.getenv("RWD"))


library(convey)
library(survey)
library(downloader)

if ( .Platform$OS.type != 'windows' ) options( encoding="windows-1252" )				

years.to.download <- 2011

source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Pesquisa%20Nacional%20por%20Amostra%20de%20Domicilios/download%20all%20microdata.R" , prompt = FALSE , echo = TRUE )


pnad.dbfolder <- paste0( getwd() , "/MonetDB" )
db <- dbConnect( MonetDBLite::MonetDBLite() , pnad.dbfolder )
dbListTables(db)

sample.pnad <- svydesign( id = ~v4618 , strata = ~v4617 , data = 'pnad2011' , weights = ~pre_wgt , nest = TRUE , dbtype = "MonetDBLite" , dbname = pnad.dbfolder )

sample.pnad <- convey_prep( sample.pnad )

dbGetQuery( db , "select * from pnad2011 limit 1" )

options(survey.lonely.psu = "adjust")

svypoormed( ~v4720 , sample.pnad , na.rm = TRUE )
