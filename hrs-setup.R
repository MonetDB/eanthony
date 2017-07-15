setwd( Sys.getenv( "RWD" ) )

hrs_username <- readRDS( "hrs_username.rds" )

hrs_password <- readRDS( "hrs_password.rds" )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"HRS\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"username"' , 'hrs_username' ) ,
		
		c( '"password"' , 'hrs_password' )
		
	)

source( lodown::syntaxtractor( "hrs" , replacements = machine_specific_replacements , setup_test = "setup" ) , echo = TRUE )
