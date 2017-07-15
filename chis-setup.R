setwd( Sys.getenv( "RWD" ) )

chis_username <- readRDS( "chis_username.rds" )

chis_password <- readRDS( "chis_password.rds" )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"CHIS\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"username"' , 'chis_username' ) ,
		
		c( '"password"' , 'chis_password' )
		
	)

source( lodown::syntaxtractor( "chis" , replacements = machine_specific_replacements , setup_test = "setup" ) , echo = TRUE )
