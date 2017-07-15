setwd( Sys.getenv( "RWD" ) )

my_email_address <- readRDS( "my_email_address.rds" )

psid_password <- readRDS( "psid_password.rds" )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"PSID\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"email@address.com"' , 'my_email_address' ) ,
		
		c( '"password"' , 'psid_password' )
		
	)

source( lodown::syntaxtractor( "psid" , replacements = machine_specific_replacements , setup_test = "setup" ) , echo = TRUE )
