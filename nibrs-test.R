my_email_address <- readRDS( "my_email_address.rds" )

icpsr_password <- readRDS( "icpsr_password.rds" )

setwd( Sys.getenv( "RWD" ) )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"NIBRS\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"email@address.com"' , 'my_email_address' ) ,
		
		c( '"password"' , 'icpsr_password' )
		
	)

source( lodown::syntaxtractor( "nibrs" , replacements = machine_specific_replacements , setup_test = "test" ) , echo = TRUE )
