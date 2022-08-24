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

# at startup..

# define location of the titles metadata file
# CHANGE THIS DEFINITION IF FILE MOVES, ETC.
metafile <- "/mnt/code/metadata/titles.csv"

# define the repo object which is used for git functions
repo <- repository("/mnt/code")

#load the metadata from the (git repo) file system
#titlesraw <- read.csv(file = metafile)

# Load the metadata from S3 bucket
titlesraw <- s3read_using(FUN=read.csv, object="s3://titles-metadata/Titles.csv")
#titles <- titlesraw %>%
#  select(!starts_with('length'))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # reactive value used for the log messages
  log <- reactiveValues(msg = NULL)

  # utility function
  add_log <- function(message="no message") {
    paste(log$msg, message, sep="\n")
  }

  # make the titles table editable in the UI  
  output$table <- DT::renderDataTable({
    datatable(titlesraw %>% 
                select(!starts_with('length')), 
              editable=TRUE)} ) 

  # error dialog displayed when no commit message
  noCommitDialog <- function() {
    modalDialog(
      title = "Oops!",
      "You need to enter a commit message."
    )
  }
  
  
  # process the Sync button on the Save tab
  observeEvent( input$Sync, {
    if (is.null(input$msg) || (input$msg == '')) {
      showModal(noCommitDialog())
    } else {
      # there is a commit message so save dataset and commit
      # log$msg <- add_log("Saving titles dataset")
      # write.csv(titlesraw, input$path, row.names=TRUE)
      # log$msg <- add_log("Add metadata to git stage")
      # add(repo, metafile)
      # log$msg <- add_log("Commit changes")
      # commit(repo,input$msg)
      # log$msg <- add_log("push to remote")
      # push(repo)
      
      # write to s3 bucket
      log$msg <- add_log("Writing to S3 bucket")
      s3write_using( titlesraw, FUN=write.csv, bucket="titles-metadata", object="Titles.csv")
      log$msg <- add_log("Done")
    }
  })
  
  
  output$info <- renderText({
    if(!is.null(log$msg))
      log$msg
  })
})


