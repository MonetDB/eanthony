setwd( Sys.getenv( "RWD" ) )
a <- lodown::get_catalog("censo")
# don't do 2000 it's been broken forever
lodown::lodown("censo", catalog=a[a$year == 2010,], output_dir= getwd())
