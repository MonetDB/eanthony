

# run the exact same convey_testthats again, post-shutdown.

library(lodown)
temp_file <- tempfile()
download.file( "https://raw.githubusercontent.com/ajdamico/eanthony/master/convey_devtools-setup.R" , temp_file , mode = 'wb' )
source( temp_file , echo = TRUE )

