
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(
        pageWithSidebar(
  # Application title
                headerPanel("Predicting Your Child's Adult Height"),

  # Sidebar with user input fields
                sidebarPanel(
                        h3('Input Panel'),
                        checkboxGroupInput("pheight", 
                               label = h4("Parents Height to Include"), 
                               choices = list("Father" = "father", 
                                              "Mother" = "mother"),
                               selected = "father"),
                                numericInput('fheight', "Father's Height (in inches)", 65, min = 0, max = 100, step = 0.5),
                                numericInput('mheight', "Mother's Height (in inches)", 65, min = 0, max = 100, step = 0.5),
                                radioButtons('cgender', "Child's Gender", choices = list("Male" = "male", "Female" = "female"), selected = "male"),
                                submitButton('Submit'),
                
                        h4("How this work?"),
                        p("Selecting the predictors (father's or mother's heights or both) used allows the app to select the appropriate regression model to use to predict the child's adult height based on regressions ran on Galton's dataset."),
                        
                        h5("Developed by", a("Kevin Low", href="http://kevinlxk.wordpress.com"), "2014.")
                
                ),

    # Show a plot of the generated distribution
                mainPanel(
                        h3("About"),
                        p("This application takes your heights and attempts to predict your children heights using the regression models based on available inputs of parents' heights, relying on data from Galton's Notebook (1886)."),
                        
                        h3('Instructions'),
                        p("This app provides you an opportunity to predict your child's adult height using you & your spouse/partner's heights. On the side panel, first select whether you are including the father or mother or both's height into the model. Next, enter the heights in inches; then select the gender of your child whose height you are trying predict."),
            
                        h3('User Inputs'),
                        p("You have selected to predict child's height with that of:"),
                        verbatimTextOutput("parents"),
                        p("The heights you input are as follows:"),
                        verbatimTextOutput("heights"),
                        p("Your child's gender selected is"),
                        verbatimTextOutput("gender"),                       
                        
                        h3("Predicted Height"),
                        p("The predicted height of your child (in inches) is:"),
                        verbatimTextOutput("cheight"),
                        
                        h3("Predicted Height on Child Height Distribution"),
                        p("The red line indicates the position of your child's predicted adult height on the distribution of child's heights on Galton's dataset. Absence of a red line indicates that the predicted height is not within the range of available data."),
                        plotOutput('hplot'),
                        
                        h3("References"),
                        p("Galton's Notebook (1886) dataset from R's", em('HistData'), "Package")
                )
        )
)
