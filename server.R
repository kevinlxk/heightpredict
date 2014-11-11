
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
require(HistData)
library(HistData)
pcheck <- function(pheight) {
        # This function checks which parent height are used and alters the state variable
        if (length(pheight) == 1) {
                if (pheight == "father"){
                        pstate <<- 1
                        return("Father")
                } else {
                        pstate <<- 2
                        return("Mother")
                }
        } else if (length(pheight) == 2) {
                pstate <<- 3
                return("Both Parents")
        } else {
                return("Please input predicting variables and hit 'Submit'")
        }
}

heights <- function(pheight, fheight, mheight) {
        if (length(pheight) == 1 & pheight[1] == "father") {
                return(fheight)
        } else if (length(pheight) == 1 & pheight[1] == "mother") {
                return(mheight)
        } else {
                both <- c(fheight,mheight)
                return(both)
        }
}

modsel <- function(pheight, fheight, mheight, cgender) {
        cheight <- 65
        fmod <- function(fheight,cgender) {
                a <- 35.6791
                bf <- 0.4104
                gen <- 5.1805
                cheight <<- a + bf*fheight + gen*(as.numeric(cgender == "male"))
        }
        mmod <- function(mheight,cgender) {
                a <- 42.1012
                bm <- 0.3430
                gen <- 5.16975
                cheight <<- a + bm*mheight + gen*(as.numeric(cgender == "male"))
        }
        bmod <- function(fheight,mheight,cgender) {
                a <- 16.52124
                bf <- 0.39284
                bm <- 0.31761
                gen <- 5.21499
                cheight <<- a + bf*fheight + bm*mheight + gen*(as.numeric(cgender == "male"))
        }
        if (length(pheight) == 1) {
                if (pheight[1] == "father") {
                        fmod(fheight,cgender)
                } else if (pheight[1] == "mother") {
                        mmod(mheight,cgender)
                }
        } else {
                bmod(fheight,mheight,cgender)
        }
        cheight
}


library(shiny)

shinyServer(function(input, output) {
        
        # We want to be able to print the user's inputs first to confirm
        output$parents <- renderPrint({pcheck(input$pheight)})
        output$heights <- renderPrint({heights(input$pheight, input$fheight,input$mheight)})
        output$gender <- renderPrint({input$cgender})
        
        # We then want to generate outputs based on the models used
        output$cheight <- renderPrint({modsel(input$pheight, input$fheight, input$mheight, input$cgender)})
        output$hplot <- renderPlot({
                hist(GaltonFamilies$childHeight, xlab = "Child's Heights", col = "lightblue", main = "Height Distribution", breaks = 20)
                cheight <- modsel(input$pheight, input$fheight, input$mheight, input$cgender)
                lines(x = c(cheight, cheight), y = c(0,150), col = "red", lwd = 5)
        })
})
