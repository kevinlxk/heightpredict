
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
                        return("Father")
                } else {
                        return("Mother")
                }
        } else if (length(pheight) == 2) {
                return("Both Parents")
        } else {
                return("Please input predicting variables")
        }
}

heights <- function(pheight, fheight, mheight) {
        if (length(pheight) == 1 & pheight[1] == "father") {
                return(fheight)
        } else if (length(pheight) == 1 & pheight[1] == "mother") {
                return(mheight)
        } else if (length(pheight) == 2) {
                both <- c(fheight,mheight)
                return(both)
        } else {
                return("Please input predicting variables")
        }
}

modsel <- function(pheight = 1, fheight, mheight, cgender) {
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
        round(cheight, digits = 3)
}

library(shiny)

shinyServer(function(input, output) {
        
        # We want to be able to print the user's inputs first to confirm
        output$parents <- renderText({paste("You have selected to predict child\'s height with that of:", pcheck(input$pheight))})
        output$heights <- renderText({paste("You have entered parent(s) height(s) of:", paste(heights(input$pheight, input$fheight, input$mheight), collapse = " and "))})
        output$gender <- renderText({paste("Your selected child gender is", input$cgender, collapse = " ")})
        
        # We then want to generate outputs based on the models used
        output$cheight <- renderText({paste("Your child's predicted height is", modsel(input$pheight, input$fheight*as.numeric(input$units), input$mheight*as.numeric(input$units), input$cgender), 
                                            "inches or",
                                            2.54*modsel(input$pheight, input$fheight*as.numeric(input$units), input$mheight*as.numeric(input$units), input$cgender), "cm", collapse = "")})
        
        output$hplot <- renderPlot({
                dat <- subset(GaltonFamilies, gender == input$cgender, select = childHeight)
                hist(dat$childHeight, xlab = "Child's Heights (in inches)", ylab = "Counts", col = "lightblue", main = "Height Distribution (same gender)", breaks = 20)
                cheight <- modsel(input$pheight, input$fheight, input$mheight, input$cgender)
                lines(x = c(cheight, cheight), y = c(0,150), col = "red", lwd = 5)
        })
        output$hplot2 <- renderPlot({
                hist(GaltonFamilies$childHeight, xlab = "Child's Heights (in inches)", ylab = "Counts", col = "lightblue", main = "Height Distribution (both gender)", breaks = 20)
                cheight <- modsel(input$pheight, input$fheight, input$mheight, input$cgender)
                lines(x = c(cheight, cheight), y = c(0,150), col = "red", lwd = 5)
        })
})
