setwd( Sys.getenv( "RWD" ) )

my_name <- readRDS( "my_name.rds" )

my_org <- readRDS( "my_org.rds" )

my_phone <- readRDS( "my_phone.rds" )

my_email_address <- readRDS( "my_email_address.rds" )

machine_specific_replacements <- 
	list( 
		
		# replace the folder path on macnix
		c( 'path.expand( \"~\" ) , \"PEW\"' , paste0( '"' , getwd() , '"' ) ) ,
		
		# change other things in the script to be run
		c( "hello" , "howdy" ) ,
		
		c( '"email@address.com"' , 'my_email_address' ) ,
		
		c( '"your name"' , 'my_name' ) ,
		
		c( '"your organization"' , 'my_org' ) ,
		
		c( '"your phone"' , 'my_phone' )
		
	)

source( lodown::syntaxtractor( "pew" , replacements = machine_specific_replacements , setup_test = "test" ) , echo = TRUE )
