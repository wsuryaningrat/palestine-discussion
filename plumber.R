# This plumber API is used to
# 1. Upload model rds file to NFS server Datalis (out_scorecard.rds or out_ml.rds)
# 2. Upload r script plumber.R
# 3. Upload r script run_api.R

library(httr) 
library(jsonlite)
library(fs)

#here path directory server for deployment file from desktop
path_source  <- "/app/api_scorecard/" #directory docker untuk dimount ke /apps/scorecard/source/api_scorecard

# Endpoint 1 ----------------------------------------------------------------
#* Upload rds data from desktop app to directory server datalis using parser 
#* @parser rds
#* @parser multi
#* @post /upload_rds
function(req, res,rds_file) {
  
  tryCatch(
    { 
      time_start <- Sys.time()
      multi <- mime::parse_multipart(req)
      file_name <- multi$file_name

      print('Starting API endpoint /upload_rds') 
      print(paste0('Time start: ',time_start))  
      print('Reading file')  
      print(file_name)
      print('...')

      path_rds <- path(paste0(path_source,file_name)) 
      #path_rds <- path(paste0(file_name)) 
      print(paste0('Saving RDS file to directory server'))
      saveRDS(rds_file[[1]], path_rds)

      response_time <- Sys.time() - time_start
      response_time_ms <- as.numeric(as.difftime(response_time,units='secs')) * 1000 
      response_time_ms <- round(response_time_ms,5)  

      print('Done upload rds')
      print(paste0('Procces time:',response_time_ms))
      print('...')

      list_return = list(
      'status'=200,
      'message'=unbox('Done upload RDS')
      ) 
      list_return = jsonlite::toJSON(list_return, force=TRUE) 
      return(fromJSON(list_return)) 

    },
    # ... but if an error occurs, tell me what happened:
    error=function(er){
      print('Failed to upload RDS')
      print(er$message)
      print('...')

    list_err = list(
      'status'=400,
      'message'=unbox('failed to upload rds'),
      'detail'=er$message
    )
    list_err = jsonlite::toJSON(list_err, force=TRUE)

    return(fromJSON(list_err))

    }
  ) 
}
#Endpoint 2
#* Upload R Script Plumber from desktop app to directory server datalis using parser 
#* @post /upload_script
function(req, res) { 
  tryCatch({

      print('Starting API endpoint /upload_script')
      
      time_start <- Sys.time()
      multi <- mime::parse_multipart(req) 
      file_name <- multi$file_name
      r_script <- multi$r_script 
  
  
      print(paste0('Time start: ',time_start))  
      print('Reading script')
      print('...') 
      
      cleaned_script <- paste(r_script[[1]],collapse = '\n')

      print(paste0('Saving R Script to directory server: '))
      path_script <- path(paste0(path_source,file_name))
      writeLines(text = cleaned_script,con = path_script,sep = '') 

      response_time <- Sys.time() - time_start
      response_time_ms <- as.numeric(as.difftime(response_time,units='secs')) * 1000 
      response_time_ms <- round(response_time_ms,5)  

      print('Done upload r script')
      print(paste0('Procces time:',response_time_ms))
      print('...')

      list_return = list(
      'status'=200,
      'message'=unbox('Done upload r script')
      ) 
      list_return = jsonlite::toJSON(list_return, force=TRUE) 
      return(fromJSON(list_return)) 
      },
    # ... but if an error occurs, tell me what happened:
    error=function(er){
      print('Failed to upload R Script')
      print(er$message) 
      print('...')

    list_err = list(
      'status'=400,
      'message'=unbox('failed to upload r script'),
      'detail'=er$message
    )
    list_err = jsonlite::toJSON(list_err, force=TRUE) 
    return(fromJSON(list_err)) 
    }
  ) 
}
