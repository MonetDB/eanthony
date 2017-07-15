setwd( Sys.getenv( "RWD" ) )

share_username <- readRDS( "share_username.rds" )

share_password <- readRDS( "share_password.rds" )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"SHARE\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"username"' , 'share_username' ) ,
		
		c( '"password"' , 'share_password' )
		
	)

source( lodown::syntaxtractor( "share" , replacements = machine_specific_replacements , setup_test = "setup" ) , echo = TRUE )
