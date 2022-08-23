#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Metadata Editor",
               tabPanel("Config", 
                        fluidPage(
                            textInput("s3url", "S3 Object url", value="s3://titles-metadata/Titles.csv"),
                            actionButton("load", "Load Metadata")
                        )),
               tabPanel("Editor",
                        fluidPage(
                            mainPanel( dataTableOutput("table"))
                        ))
    )
)

