setwd( Sys.getenv( "RWD" ) )

# option to disable cache because geofabrik files are too big
options( "lodown.cachaca.savecache" = FALSE )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'paste0( file.path( path.expand( \"~\" ) ) )' , getwd() ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" )
		
	)

source( lodown::syntaxtractor( "geofabrik" , replacements = machine_specific_replacements , setup_test = "test" ) , echo = TRUE )
