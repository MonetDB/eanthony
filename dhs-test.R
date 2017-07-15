setwd( Sys.getenv( "RWD" ) )

my_email_address <- readRDS( "my_email_address.rds" )

dhs_password <- readRDS( "dhs_password.rds" )

dhs_project <- readRDS( "dhs_project.rds" )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"DHS\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"email@address.com"' , 'my_email_address' ) ,
		
		c( '"password"' , 'dhs_password' ) ,
		
		c( '"project"' , 'dhs_project' )
		
	)

source( lodown::syntaxtractor( "dhs" , replacements = machine_specific_replacements , setup_test = "test" ) , echo = TRUE )
