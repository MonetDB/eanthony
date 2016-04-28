setwd(Sys.getenv("RWD"))

library(DBI)
library(MonetDBLite)
library(MonetDB.R)
library(survey)


dbfolder <- paste0( getwd() , "/MonetDB" )


data(api)
db <- dbConnect( MonetDBLite() , dbfolder )


xtabs(~sch.wide+stype, data=apipop)

# dclus1<-svydesign(id=~dnum, weights=~pw, data=apiclus1, fpc=~fpc)
x <- apiclus1
names( x ) <- gsub( "\\." , "_" , names( x ) )
dbWriteTable( db , 'apiclus1' , x )
dclus1<-svydesign(id = ~dnum, weight=~pw,data = 'apiclus1',fpc = ~fpc,
	dbtype="MonetDBLite",dbname = dbfolder)


summary(dclus1)

(tbl <- svytable(~sch_wide+stype, dclus1))
plot(tbl)
fourfoldplot(svytable(~sch_wide+comp_imp+stype,design=dclus1,round=TRUE), conf.level=0)

svychisq(~sch_wide+stype, dclus1)
summary(tbl, statistic="Chisq")

# bug in svychisq for database-backed designs
# svychisq(~sch_wide+stype, dclus1, statistic="adjWald")

# rclus1<-as.svrepdesign(dclus1)
repweights<-data.frame( 2*sapply( rep( nrow( x ) , 4 ) ,  function( z )sample( 0:1 , z , replace = TRUE )) )
y <- cbind( x , repweights )
names( y ) <- tolower( names( y ) )
dbWriteTable( db , 'rclus1' , y )

rclus1<-svrepdesign(data='rclus1', type="BRR", repweights="x[1-4]", combined.weights=FALSE,
	dbtype="MonetDBLite",dbname = dbfolder)

summary(svytable(~sch_wide+stype, rclus1))

# bug in svychisq for database-backed designs
# svychisq(~sch_wide+stype, rclus1, statistic="adjWald")