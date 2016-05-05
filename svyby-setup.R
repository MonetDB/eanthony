setwd(Sys.getenv("RWD"))

library(DBI)
library(MonetDBLite)
library(MonetDB.R)
library(survey)


dbfolder <- paste0( getwd() , "/MonetDB" )


data(api)
db <- dbConnect( MonetDBLite() , dbfolder )

## one-stage cluster sample
# dclus1<-svydesign(id=~dnum, weights=~pw, data=apiclus1, fpc=~fpc)
x <- apiclus1
names( x ) <- gsub( "\\." , "_" , names( x ) )
dbWriteTable( db , 'apiclus1' , x )
dclus1<-svydesign(id = ~dnum, weight=~pw,data = 'apiclus1',fpc = ~fpc,
	dbtype="MonetDBLite",dbname = dbfolder)

	
svyby(~api99, ~stype, dclus1, svymean)
svyby(~api99, ~stype, dclus1, svyquantile, quantiles=0.5,ci=TRUE,vartype="ci")
## without ci=TRUE svyquantile does not compute standard errors
svyby(~api99, ~stype, dclus1, svyquantile, quantiles=0.5, keep.var=FALSE)
svyby(~api99, list(school_type=apiclus1$stype), dclus1, svymean)
svyby(~api99+api00, ~stype, dclus1, svymean, deff=TRUE,vartype="ci")
svyby(~api99+api00, ~stype+sch_wide, dclus1, svymean, keep.var=FALSE)
## report raw number of observations
svyby(~api99+api00, ~stype+sch_wide, dclus1, unwtd.count, keep.var=FALSE)

# rclus1<-as.svrepdesign(dclus1)
repweights<-data.frame( 2*sapply( rep( nrow( x ) , 4 ) ,  function( z )sample( 0:1 , z , replace = TRUE )) )
y <- cbind( x , repweights )
names( y ) <- tolower( names( y ) )
dbWriteTable( db , 'rclus1' , y )

rclus1<-svrepdesign(data='rclus1', type="BRR", repweights="x[1-4]", combined.weights=FALSE,
	dbtype="MonetDBLite",dbname = dbfolder)

svyby(~api99, ~stype, rclus1, svymean)
svyby(~api99, ~stype, rclus1, svyquantile, quantiles=0.5)
svyby(~api99, list(school_type=apiclus1$stype), rclus1, svymean, vartype="cv")
svyby(~enroll,~stype, rclus1,svytotal, deff=TRUE)
svyby(~api99+api00, ~stype+sch_wide, rclus1, svymean, keep.var=FALSE)
##report raw number of observations
svyby(~api99+api00, ~stype+sch_wide, rclus1, unwtd.count, keep.var=FALSE)

## comparing subgroups using covmat=TRUE
mns<-svyby(~api99, ~stype, rclus1, svymean,covmat=TRUE)
vcov(mns)
svycontrast(mns, c(E = 1, M = -1))

str(svyby(~api99, ~stype, rclus1, svymean,return.replicates=TRUE))


## extractor functions
(a<-svyby(~enroll, ~stype, rclus1, svytotal, deff=TRUE, verbose=TRUE, 
  vartype=c("se","cv","cvpct","var")))
deff(a)
SE(a)
cv(a)
coef(a)
confint(a, df=degf(rclus1))

## ratio estimates
svyby(~api_stu+enroll, by=~stype, denominator=~enroll, design=dclus1, svyratio)

## empty groups
svyby(~api00,~comp_imp+sch_wide,design=dclus1,svymean)
svyby(~api00,~comp_imp+sch_wide,design=dclus1,svymean,drop.empty.groups=FALSE)

