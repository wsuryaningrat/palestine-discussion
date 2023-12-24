# run_api.R 
library(plumber)
plumb(file = "app/plumber.R")$run(port = 8013, host = "0.0.0.0", swagger = TRUE)
