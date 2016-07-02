setwd(Sys.getenv("RWD"))


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
			if( length( missing_packages ) > 0 ) try( install.packages( missing_packages , repos = "http://cran.rstudio.com/" , type = 'both' ) , silent = TRUE )
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

		prior_missing <- ''
		missing_packages <- NULL
		
		while( ( class( failed_dep ) == 'try-error' ) & !identical( missing_packages , prior_missing ) ){
			
			missing_packages <- gsub( "(.*)Dependency package (.*) not available(.*)" , "\\2" , failed_dep[1] )

			install.packages( missing_packages , repos = "http://cran.rstudio.com/" , type = 'both' )
			
			prior_missing <- missing_packages
			
			failed_dep <- try( devtools::load_all(local_file_path) , silent = TRUE )
			
		}
			

		# using the package source from cran, figure out the errors in the current version using RSQLite #

		# before without run don't test
		before_wo_rdt <- devtools::check( local_file_path , quiet = TRUE )

		# before with run don't test
		before_w_rdt <- devtools::check( local_file_path , run_dont_test = TRUE , quiet = TRUE )


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

		# before without run don't test
		after_w_rdt <- devtools::check( local_file_path , quiet = TRUE )

		# before with run don't test
		after_wo_rdt <- devtools::check( local_file_path , run_dont_test = TRUE , quiet = TRUE )


		# moment of truth: did overwriting MonetDBLite with RSQLite affect anything?
		for( i in c( 'errors' , 'warnings' , 'notes' ) ){

			if( !identical( before_wo_rdt[ i ] , after_wo_rdt[ i ] ) ){

				cat( "\n\n\nbefore SQLite -> MonetDBLite replacement\n\n\n" )
				print( before_wo_rdt )
				cat( "\n\n\nafter SQLite -> MonetDBLite replacement\n\n\n" )
				print( after_wo_rdt )

				stop( paste( i , "before vs after output does not match with run_dont_test=FALSE" ) )
				
			}

			if( !identical( before_w_rdt[ i ] , after_w_rdt[ i ] ) ){

				cat( "\n\n\nbefore SQLite -> MonetDBLite replacement\n\n\n" )
				print( before_w_rdt )
				cat( "\n\n\nafter SQLite -> MonetDBLite replacement\n\n\n" )
				print( after_w_rdt )
				
				stop( paste( i , "before vs after output does not match with run_dont_test=TRUE" ) )

			}
			
		}

		TRUE
	}
	

# works july 2nd, 2016
replace_sqlite_with_monetdblite_in_cran_pkgs( 'twitteR' )


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

# in a perfect world:
# for( j in c( RSQLite_reverse_imports , RSQLite_reverse_depends , RSQLite_reverse_suggests ) ) replace_sqlite_with_monetdblite_in_cran_pkgs( j )
