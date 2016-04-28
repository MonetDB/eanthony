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

svymean(~api00, dclus1, deff=TRUE)
svymean(~factor(stype),dclus1)
svymean(~interaction(stype, comp_imp), dclus1)
svyquantile(~api00, dclus1, c(.25,.5,.75))
svytotal(~enroll, dclus1, deff=TRUE)
svyratio(~api_stu, ~enroll, dclus1)

v<-svyvar(~api00+api99, dclus1)
v
print(v, cov=TRUE)
as.matrix(v)


# jkstrat<-as.svrepdesign(dstrat)
# replicate weights - jackknife (this is slower)
x <- apistrat
repweights<-data.frame( 2*sapply( rep( nrow( x ) , 4 ) ,  function( z )sample( 0:1 , z , replace = TRUE )) )
names( x ) <- gsub( "\\." , "_" , names( x ) )
y <- cbind( x , repweights )
names( y ) <- tolower( names( y ) )
dbWriteTable( db , 'apistrat' , y )

dstrat<-svydesign(id=~1,strata=~stype, weights=~pw,data='apistrat', fpc=~fpc,
	dbtype="MonetDBLite",dbname = dbfolder)
	
svymean(~api00, dstrat)
svymean(~factor(stype),dstrat)
svyvar(~api00+api99,dstrat)

svyquantile(~api00, dstrat, c(.25,.5,.75))
svytotal(~enroll, dstrat)
svyratio(~api_stu, ~enroll, dstrat)

# coefficients of variation
cv(svytotal(~enroll,dstrat))
cv(svyratio(~api_stu, ~enroll, dstrat))

# extracting information from the results
coef(svytotal(~enroll,dstrat))
vcov(svymean(~api00+api99,dstrat))
SE(svymean(~enroll, dstrat))
confint(svymean(~api00+api00, dclus1))
confint(svymean(~api00+api00, dclus1), df=degf(dclus1))

# Design effect
svymean(~api00, dstrat, deff=TRUE)
svymean(~api00, dstrat, deff="replace")
svymean(~api00, dstrat, deff=TRUE)
svymean(~api00, dstrat, deff="replace")
(a<-svytotal(~enroll, dclus1, deff=TRUE))
deff(a)
