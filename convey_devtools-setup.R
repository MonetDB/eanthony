setwd(Sys.getenv("RWD"))

tf <- tempfile()
download.file( "https://github.com/DjalmaPessoa/convey/archive/master.zip" , tf , mode = 'wb' )

for( j in 1:8 ){
	message("Run ", j)

	this_tempdir_a <- paste0( tempdir() , j , 'a' )
	this_tempdir_b <- paste0( tempdir() , j , 'b' )
	this_tempdir_c <- paste0( tempdir() , j , 'c' )
	
	dir.create( this_tempdir_a )
	unzip( tf , exdir = this_tempdir_a )
	dtt <- devtools::test( paste0( this_tempdir_a , '/convey-master' ) )
	print( dtt )
	if( any( dtt$error ) ) stop( paste0( "devtools::test returned an error on iteration " , j ) )
	MonetDBLite::monetdblite_shutdown()
	unlink( this_tempdir_a , recursive = TRUE ) ; Sys.sleep( 10 )
	
	dir.create( this_tempdir_b )
	unzip( tf , exdir = this_tempdir_b )
	dtc <- devtools::check( paste0( this_tempdir_b , '/convey-master' ) , vignettes = FALSE )
	print( dtc )
	if( length( dtc$errors ) > 0 ) stop( paste0( "devtools::check returned an error on iteration " , j ) )
	MonetDBLite::monetdblite_shutdown()
	unlink( this_tempdir_b , recursive = TRUE ) ; Sys.sleep( 10 )

	dir.create( this_tempdir_c )
	unzip( tf , exdir = this_tempdir_c )
	dtcrdt <- devtools::check( paste0( this_tempdir_c , '/convey-master' ) , run_dont_test = TRUE , vignettes = FALSE )
	print( dtcrdt )
	if( length( dtcrdt$errors ) > 0 ) stop( paste0( "devtools::check with run_dont_test=TRUE returned an error on iteration " , j ) )
	MonetDBLite::monetdblite_shutdown()
	unlink( this_tempdir_c , recursive = TRUE ) ; Sys.sleep( 10 )
}

warnings()
# corruption sniffing
db <- dbConnect( MonetDBLite::MonetDBLite() )
cs <- dbGetQuery( db , "select tables.name, columns.name, location from tables inner join columns on tables.id=columns.table_id left join storage on tables.name=storage.table and columns.name=storage.column where location is null and tables.name not in ('tables', 'columns', 'users', 'querylog_catalog', 'querylog_calls', 'querylog_history', 'tracelog', 'sessions', 'optimizers', 'environment', 'queue', 'rejects', 'storage', 'storagemodel', 'tablestoragemodel')" )
print(cs)
stopifnot(nrow(cs) == 0) ; dbDisconnect( db , shutdown = TRUE )

