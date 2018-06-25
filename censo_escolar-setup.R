setwd( Sys.getenv( "RWD" ) )

a <- lodown::get_catalog("censo_escolar")
# don't do 2017 it's been broken forever
lodown::lodown("censo_escolar", catalog=a[a$year < 2017,], output_dir= getwd())
