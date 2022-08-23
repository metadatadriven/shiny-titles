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

# Load the metadata from S3 bucket
# install.packages("aws.s3")
library(aws.s3)
titles <- s3read_using(FUN=read.csv, object="s3://titles-metadata/Titles.csv")

data(iris)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    observeEvent(input$s3url, output$table <- "loaded"  ) # TODO: fix me

    output$table <- renderDataTable(iris)

})
