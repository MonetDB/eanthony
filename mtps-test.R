setwd( Sys.getenv( "RWD" ) )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'file.path( path.expand( \"~\" ) ) \"MTPS\" )' , getwd() ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" )
		
	)

source( lodown::syntaxtractor( "mtps" , replacements = machine_specific_replacements , setup_test = "test" ) , echo = TRUE )