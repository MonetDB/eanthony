setwd(Sys.getenv("RWD"))


if (.Platform$OS.type == 'windows' ) options("pkgType"='both')


replace_sqlite_with_monetdblite_in_cran_pkgs <-
	function( package_name ){

		if ( !exists( "download_cached" ) ){
				# load the download_cached and related functions
				# to prevent re-downloading of files once they've been downloaded.
				downloader::source_url( 
					"https://raw.githubusercontent.com/ajdamico/asdfree/master/Download%20Cache/download%20cache.R" , 
					prompt = FALSE , 
					echo = FALSE 
				)
		}

		tf <- tempfile()

		# identify the source filepath and the package suggestions
		cran_page <- readLines( paste0( "https://cran.r-project.org/web/packages/" , package_name , "/index.html" ) )
		cran_version <- gsub( '<td>|</td>' , '' , cran_page[ grep( "Version:" , cran_page ) + 1 ] )
		package_source <- paste0( "https://cran.r-project.org/src/contrib/" , package_name , "_" , cran_version , ".tar.gz" )

		# download the package suggestions
		if( length( grep( "Suggests:" , cran_page ) ) > 0 ){
			cran_suggests <- gsub( "(.*)>(.*)<(.*)" , "\\2" , strsplit( gsub( '<td>|</td>' , '' , cran_page[ grep( "Suggests:" , cran_page ) + 1 ] ) , "," )[[1]] )
			missing_packages <- cran_suggests[ !cran_suggests %in% rownames(installed.packages()) ]
			
			# some packages are not available on windows, so just do yer best
			if( length( missing_packages ) > 0 ) try( install.packages( missing_packages , repos = "http://cran.rstudio.com/" , verbose = FALSE , quiet = TRUE ) , silent = TRUE )
		}
		
		# download the package source file
		download_cached( package_source , tf , mode = 'wb' )

		untar( tf , exdir = tempdir() )

		local_file_path <- file.path( tempdir() , package_name )

		unzipped_files <- 
			list.files( 
				local_file_path , 
				recursive = TRUE , 
				full.names = TRUE 
			)

		# check for dependencies not currently available
		failed_dep <- try( devtools::load_all(local_file_path) , silent = TRUE )

		if( class( failed_dep ) == 'try-error' ){
			
			prior_missing <- ''
			missing_packages <- NULL
			
			while( !identical( missing_packages , prior_missing ) ){
				
				missing_packages <- gsub( "(.*)Dependency package (.*) not available(.*)" , "\\2" , failed_dep[1] )

				install.packages( missing_packages , repos = "http://cran.rstudio.com/" , verbose = FALSE , quiet = TRUE )
				
				prior_missing <- missing_packages
				
				failed_dep <- try( devtools::load_all(local_file_path) , silent = TRUE )
				
				missing_packages <- gsub( "(.*)Dependency package (.*) not available(.*)" , "\\2" , failed_dep[1] )

			}
			
		}

		# using the package source from cran, figure out the errors in the current version using RSQLite #

		# before without run don't test or vignettes
		before_output <- devtools::check( local_file_path , quiet = TRUE , vignettes = FALSE )

		# before without run don't test
		try( before_output <- devtools::check( local_file_path , quiet = TRUE ) , silent = TRUE )

		# before with run don't test
		try( before_output <- devtools::check( local_file_path , run_dont_test = TRUE , quiet = TRUE ) , silent = TRUE )


		# overwrite RSQLite with MonetDBLite
		# THEN
		# overwrite SQLite with MonetDBLite
		for( this_file in unzipped_files ){
			
			w <- readLines( this_file )
			w <- gsub( "RSQLite" , "MonetDBLite" , w )
			w <- gsub( "SQLiteDriver" , "MonetDBLite" , w )
			w <- gsub( "SQLite" , "MonetDBLite" , w )
			writeLines( w , this_file , sep = '\n' )

		}


		# using the package source from cran, figure out the errors in the current version using MonetDBLite #

		# before without run don't test or vignettes
		after_output <- devtools::check( local_file_path , quiet = TRUE , vignettes = FALSE )

		# before without run don't test
		try( after_output <- devtools::check( local_file_path , quiet = TRUE ) , silent = TRUE )

		# before with run don't test
		try( after_output <- devtools::check( local_file_path , run_dont_test = TRUE , quiet = TRUE ) , silent = TRUE )

		
		# moment of truth: did overwriting MonetDBLite with RSQLite affect anything?
		for( i in c( 'errors' , 'warnings' , 'notes' ) ){

			if( !identical( before_output[ i ] , after_output[ i ] ) ){

				cat( "\n\n\nbefore SQLite -> MonetDBLite replacement\n\n\n" )
				print( before_output[ i ] )
				cat( "\n\n\nafter SQLite -> MonetDBLite replacement\n\n\n" )
				print( after_output[ i ] )
				
			}

		}
		

		# if the before vs after objects are the same, return NULL else return the after-object
		if( identical( before_output , after_output ) ) invisible( NULL ) else after_output
	}
	

# works july 2nd, 2016
# replace_sqlite_with_monetdblite_in_cran_pkgs( 'twitteR' )


# replace_sqlite_with_monetdblite_in_cran_pkgs( 'trackeR' )
# replace_sqlite_with_monetdblite_in_cran_pkgs( 'poplite' )
# replace_sqlite_with_monetdblite_in_cran_pkgs( 'survey' )

# pull sqlite reverse imports line
cran_page <- readLines( "https://cran.r-project.org/web/packages/RSQLite/index.html" )
RSQLite_reverse_imports <- gsub( "(.*)>(.*)<(.*)" , "\\2" , strsplit( gsub( '<td>|</td>' , '' , cran_page[ grep( "imports:" , cran_page ) + 1 ] ) , "," )[[1]] )
RSQLite_reverse_depends <- gsub( "(.*)>(.*)<(.*)" , "\\2" , strsplit( gsub( '<td>|</td>' , '' , cran_page[ grep( "depends:" , cran_page ) + 1 ] ) , "," )[[1]] )
RSQLite_reverse_suggests <- gsub( "(.*)>(.*)<(.*)" , "\\2" , strsplit( gsub( '<td>|</td>' , '' , cran_page[ grep( "suggests:" , cran_page ) + 1 ] ) , "," )[[1]] )

# full to-do list:
RSQLite_reverse_imports
RSQLite_reverse_depends
RSQLite_reverse_suggests

for( j in c( RSQLite_reverse_imports , RSQLite_reverse_depends , RSQLite_reverse_suggests ) ) {

	print( paste( "currently attempting" , j ) )

	a <- try( b <- replace_sqlite_with_monetdblite_in_cran_pkgs( j ) , silent = TRUE )

	if( class( a ) == 'try-error' ) print( a )

}
