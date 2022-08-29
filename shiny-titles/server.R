#/*****************************************************************************\
#         O
#        /
#   O---O     _  _ _  _ _  _  _|
#        \ \/(/_| (_|| | |(/_(_|
#         O
# ______________________________________________________________________________          
# Sponsor              : Domino
# Compound             : Xanomeline
# Study                : H2QMCLZZT
# Analysis             : n/a
# Program              : server.r
# Purpose              : Shiny server for titles metadata editor 
#_______________________________________________________________________________                            
# DESCRIPTION
#                           
# Input files: /metadata/titles.csv
#                             
# Output files: /metadata/titles.csv
#                             
# Utility functions:
# 
# Assumptions:
# - AWS environment variables are defined:
#   - AWS_ACCESS_KEY_ID
#   - AWS_SECRET_ACCESS_KEY
#   - AWS_DEFAULT_REGION
# - titles.csv file exists in valid format (no checking done)
# - file is in git repo and permissions exist to commit and push
#
#_______________________________________________________________________________
# PROGRAM HISTORY
# 24aug2022 |	Stuart Malcolm	| Original
#/*****************************************************************************\

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
library(shiny)
library(DT)
library(dplyr)
library(aws.s3)
library(git2r)
library(httr)

# at startup..

# define location of the titles metadata file
# CHANGE THIS DEFINITION IF FILE MOVES, ETC.
metafile <- "/mnt/code/metadata/Titles.csv"

# define the repo object which is used for git functions
repo <- repository("/mnt/code")

#load the metadata from the (git repo) file system
#titlesraw <- read.csv(file = metafile)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  
  # reactive value used for the log messages
  log <- reactiveValues(msg = NULL)

  # utility function
  add_log <- function(message="no message") {
    paste(log$msg, message, sep="\n")
  }

  # Load the CSV file from S3
  titlesraw = s3read_using(FUN=read.csv, object="s3://titles-metadata/Titles.csv")
  
  
  # make the titles table editable in the UI  
  output$table <- DT::renderDataTable({
    datatable(titlesraw %>% 
                select(!starts_with('length') & !starts_with('X')), 
              selection = 'none',
              editable=TRUE)} ) 

  # error dialog displayed when no commit message
  noCommitDialog <- function() {
    modalDialog(
      title = "Oops!",
      "You need to enter a commit message."
    )
  }
  
  # proxy table used by the cell-edit observer
  # see https://github.com/rstudio/DT/pull/480
  
  proxy = dataTableProxy('titlesraw')
  
  # observe any changes to the table..(cell edits)
  observeEvent( input$table_cell_edit, {
    info = input$table_cell_edit
    str(info)
    i = info$row
    j = info$col
    v = info$value
    titlesraw[i,j] <<- DT::coerceValue(v, titlesraw[i,j])
    replaceData(proxy, titlesraw, resetPaging = FALSE)
  })
  
  # process the Sync button on the Save tab
  observeEvent( input$Sync, {
    if (is.null(input$s3uri) || (input$s3uri == '')) {
      showModal(noCommitDialog())
    } else {
      # there is a commit message so save dataset and commit
      log$msg <- add_log("Saving titles dataset")
      write.csv(titlesraw, input$path, row.names=TRUE)

      # write to s3 bucket
      log$msg <- add_log("Writing to S3 bucket")
      s3write_using( titlesraw, FUN=write.csv, object=input$s3uri)

      # Trigger execution using shell script (trigger.sh)
      log$msg <- add_log("Metadata trigger execution using Domino API")
      cmd <- "/mnt/code/shiny-titles/trigger.sh 2>&1"
      rx <- system(cmd, intern=TRUE)
      log$msg <- add_log(paste("return code: ", rx))
      
    }
  })
  
# Trigger execution using Domino API
# ---------------------------------------------------------
# observeEvent( input$Trigger, {
#       # there is a commit message so save dataset and commit
#       log$msg <- add_log("Metadata Triggered Execution using Domino API")
# 
#       # curl -X POST "https://se-sandbox.domino-eval.com/v4/jobs/start" 
#       #      -H  "accept: application/json" 
#       #      -H  "X-Domino-Api-Key: 16c22313dd5f14d961595f6b7855b2a8312fa2b010bd51b303fe9959a982fdec" 
#       #      -H  "Content-Type: application/json" 
#       #      -d "{\"projectId\":\"6308d5c9c92bbb395372f3dd\",\"commandToRun\":\"python-code/pdf-generator.py\",\"title\":\"Metadata Triggered Execution using Domino API\"}"
#       
#       # response <- POST("https://se-sandbox.domino-eval.com/v4/jobs/start",
#       #                   httr::add_headers('X-Domino-Api-Key', '16c22313dd5f14d961595f6b7855b2a8312fa2b010bd51b303fe9959a982fdec'),
#       #                   accept_json() ,
#       #                   content_type_json(),
#       #                   body = jsonlite::parse_json('{"projectId" : "6308d5c9c92bbb395372f3dd",
#       #                               "commandToRun" : "python-code/pdf-generator.py",
#       #                               "title" : "Metadata Triggered Execution using Domino API"}'),
#       #                  encode = "json")
#       # log$msg <- add_log(content(response, "text"))
#       
#       
#       cmd <- "/mnt/code/shiny-titles/trigger.sh"
#       rx <- system(cmd)
#       log$msg <- add_log(rx)
#       
# })
  
  
    
  output$info <- renderText({
    if(!is.null(log$msg))
      log$msg
  })
})


