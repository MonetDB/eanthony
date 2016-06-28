setwd(Sys.getenv("RWD"))

downloader::source_url( "https://raw.githubusercontent.com/ajdamico/asdfree/master/Download%20Cache/download%20cache.R" , prompt = FALSE , echo = FALSE )

tf <- tempfile()

download_cached( "https://github.com/DjalmaPessoa/convey/archive/master.zip" , tf , mode = 'wb' , usecache = FALSE , savecache = TRUE )

for( j in 1:10 ){

	dir.create( tempdir() )
	download_cached( "https://github.com/DjalmaPessoa/convey/archive/master.zip" , tf , mode = 'wb' )
	unzip( tf , exdir = tempdir() )
	
	dtt <- devtools::test( paste0( tempdir() , '/convey-master' ) )

	print( dtt )

	if( any( dtt$error ) ) stop( paste0( "devtools::test returned an error on iteration " , j ) )

	unlink( tempdir() , recursive = TRUE ) ; Sys.sleep( 10 )
	
	dir.create( tempdir() )
	download_cached( "https://github.com/DjalmaPessoa/convey/archive/master.zip" , tf , mode = 'wb' )
	unzip( tf , exdir = tempdir() )
	
	dtc <- devtools::check( paste0( tempdir() , '/convey-master' ) , vignettes = FALSE )

	print( dtc )

	if( length( dtc$errors ) > 0 ) stop( paste0( "devtools::check returned an error on iteration " , j ) )

	unlink( tempdir() , recursive = TRUE ) ; Sys.sleep( 10 )

	dir.create( tempdir() )
	download_cached( "https://github.com/DjalmaPessoa/convey/archive/master.zip" , tf , mode = 'wb' )
	unzip( tf , exdir = tempdir() )
	
	dtcrdt <- devtools::check( paste0( tempdir() , '/convey-master' ) , run_dont_test = TRUE , vignettes = FALSE )

	print( dtcrdt )

	if( length( dtcrdt$errors ) > 0 ) stop( paste0( "devtools::check with run_dont_test=TRUE returned an error on iteration " , j ) )

	unlink( tempdir() , recursive = TRUE ) ; Sys.sleep( 10 )
	
}


warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite::MonetDBLite() )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )

