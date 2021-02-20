library(shiny)
library(ggplot2)
library(dplyr)

dropdown <- c("Blekinge", "Dalarna", "Gotland", "Gävleborg", "Halland",
              "Jämtland", "Jönköping", "Kalmar", "Kronoberg", "Norrbotten",
              "Skåne", "Stockholm", "Södermanland", "Uppsala", "Värmland",
              "Västerbotten", "Västernorrland", "Västmanland",
              "Västra_Götaland","Örebro", "Östergötland")
latest.file <- paste0("fhmCases",Sys.Date(), ".csv")

fluidPage(
  
  titlePanel("C19 - regionala trender"),
  
  sidebarPanel(
    p("Rapporterade dagliga fall av Covid-19 per region."),
    
    p(paste("Latest file:", 
            str_extract(latest.file, "\\d{4}\\-\\d{2}\\-\\d{2}"))),
    
    dateRangeInput(inputId = "daterange", 
                   label = "Datumintervall", 
                   start = "2020-01-01"),
    checkboxGroupInput("region", "Regioner", 
                choices = dropdown,
                selected = "Västerbotten", inline = T),
    checkboxInput("smoothing", "Trendlinje", value = T)
  ),
  
  mainPanel(
    plotOutput('covid')
    
  )
)
