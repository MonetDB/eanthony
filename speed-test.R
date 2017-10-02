

# run the exact same convey_testthats again, post-shutdown.

temp_file <- tempfile()
download.file( "https://raw.githubusercontent.com/MonetDB/eanthony/master/speed-setup.R" , temp_file , mode = 'wb' )
source( temp_file , echo = TRUE )

