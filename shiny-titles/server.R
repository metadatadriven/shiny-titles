#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(dplyr)
library(aws.s3)

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
      log$msg <- add_log("Saving titles dataset")
      write.csv(titles, input$path, row.names=TRUE)
    }
  })
  
  
  output$info <- renderText({
    if(!is.null(log$msg))
      log$msg
  })
})


