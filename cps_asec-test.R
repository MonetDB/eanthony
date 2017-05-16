setwd( Sys.getenv( "RWD" ) )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'paste0( file.path( path.expand( \"~\" ) ) )' , getwd() ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" )
		
	)

source( lodown::syntaxtractor( "cps_asec" , replacements = machine_specific_replacements , setup_test = "test" ) , echo = TRUE )
