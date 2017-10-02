seer_username <- readRDS( "seer username.rds" )

seer_password <- readRDS( "seer password.rds" )

setwd( Sys.getenv( "RWD" ) )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"SEER\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"username"' , 'seer_username' ) ,
		
		c( '"password"' , 'seer_password' )
		
	)

source( lodown::syntaxtractor( "seer" , replacements = machine_specific_replacements , setup_test = "setup" ) , echo = TRUE )
