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
# Purpose              : Shiny UI for titles metadata editor 
#_______________________________________________________________________________                            
# DESCRIPTION
#                           
# Input files: none
#                             
# Output files: none
#                             
# Utility functions:
# 
# Assumptions:
# - see server.r
#
#_______________________________________________________________________________
# PROGRAM HISTORY
# 24aug2022 |	Stuart Malcolm	| Original
#/*****************************************************************************\

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
    navbarPage("Metadata",
               tabPanel("Editor",
                        fluidPage(
                            mainPanel( DT::dataTableOutput("table"))
                        )),
               tabPanel("File", 
                        fluidPage(
                          textInput("path", "Local path", value = "/mnt/code/metadata/titles.csv"),
                          textInput("s3uri", "S3 Bucket URI", value = "s3://titles-metadata/Titles.csv"),
#                          textInput("msg", "Commit message"),
                          actionButton("Sync", "Save to S3"),
                          actionButton("Load", "Load from S3"),
                          verbatimTextOutput("info")
                        ))
               
               
    )
)

