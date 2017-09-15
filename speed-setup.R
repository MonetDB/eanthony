setwd(Sys.getenv("RWD"))

library(DBI)
library(data.table)

sqlite_dir <- tempfile()
sqlite_con <- dbConnect( RSQLite::SQLite() , sqlite_dir )

monetdb_dbdir <- tempdir()
monetdb_con <- dbConnect(MonetDBLite::MonetDBLite(), embedded = monetdb_dbdir)

# table to output
results <- NULL

# record number range to test
# 100 to 100,000,000
for( i in 10^(2:8) ){
	
	# basic data.table setup pulled from https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.pdf
	grpsize = ceiling(i/26)

	my_df <- 
		data.frame(
			x=rep(LETTERS,each=grpsize),
			v=runif(grpsize*26),
			stringsAsFactors=FALSE
		)
	
	my_mergetable <- data.frame( x = LETTERS , y = 1:26 )

	# data import/loading/preparation (usually a one-time operation)
	dt_l <-
		system.time({
			DT = as.data.table(my_df)
			setkey(DT,x)
			DTm = as.data.table(my_mergetable)
			setkey(DTm,x)
		})["elapsed"]
	
	if( i < 10^8 ){
		sl_l <- 
			system.time({
				dbWriteTable( sqlite_con , "my_table" , my_df ) 
				dbWriteTable( sqlite_con , "my_mergetable" , my_mergetable )
			})["elapsed"]
	} else sl_l <- NA
	
	md_l <- 
		system.time({
			dbWriteTable( monetdb_con , "my_table" , my_df ) 
			dbWriteTable( monetdb_con , "my_mergetable" , my_mergetable )
		})["elapsed"]


	# sum by group
	if( i < 10^8 ) br_s <- system.time( tapply( my_df$v , my_df$x , sum ) )["elapsed"] else br_s <- NA
	dt_s <- system.time( DT[,sum(v),by=x] )["elapsed"]
	if( i < 10^8 ) sl_s <- system.time( dbGetQuery( sqlite_con , "SELECT SUM( v ) , x FROM my_table GROUP BY x" ) )["elapsed"] else sl_s <- NA
	md_s <- system.time( dbGetQuery( monetdb_con , "SELECT SUM( v ) , x FROM my_table GROUP BY x" ) )["elapsed"]
	
	# simple merge
	if( i < 10^8 ) br_m <- system.time( mean( merge( my_df , my_mergetable )$y ) )["elapsed"] else br_m <- NA
	dt_m <- system.time( merge( DT , DTm )[,mean(y)] )["elapsed"]
	if( i < 10^8 ) sl_m <- system.time( dbGetQuery( sqlite_con , "SELECT AVG( y ) FROM ( SELECT y FROM my_table AS a INNER JOIN my_mergetable AS b ON a.x=b.x )" ) )["elapsed"] else sl_m <- NA
	md_m <- system.time( dbGetQuery( monetdb_con , "SELECT AVG( y ) FROM ( SELECT y FROM my_table AS a INNER JOIN my_mergetable AS b ON a.x=b.x ) AS zzz" ) )["elapsed"]
	
	
	results <- 
		rbind( 
			results , 
			data.frame( 
				num_recs = nrow( my_df ) , 
				data_table_load = dt_l , 
				sqlite_load = sl_l , 
				monetdb_load = md_l , 
				base_r_sum = br_s , 
				data_table_sum = dt_s , 
				sqlite_sum = sl_s , 
				monetdb_sum = md_s ,
				base_r_merge = br_m , 
				data_table_merge = dt_m , 
				sqlite_merge = sl_m , 
				monetdb_merge = md_m
			) 
		)
	
	
	if( i < 10^8 ) dbRemoveTable( sqlite_con , 'my_table' )
	dbRemoveTable( monetdb_con , 'my_table' )
	if( i < 10^8 ) dbRemoveTable( sqlite_con , 'my_mergetable' )
	dbRemoveTable( monetdb_con , 'my_mergetable' )
	rm( DT , my_df , DTm , my_mergetable ) ; gc()

}


print( results )
		

