library(shiny)
library(ggplot2)
library(tidyverse)

url <- "https://free.entryscape.com/store/360/resource/15"
latest.file <- paste0("fhmCases",Sys.Date(), ".csv")

# Update and deploy #
#rsconnect::deployApp(appFiles = c("server.r", "ui.r", latest.file), 
#                     forceUpdate = T)

if (!file.exists(latest.file)) {
  download.file(url, latest.file)
}
fhm <- read.csv(latest.file)

function(input, output) {

  output$covid <- renderPlot({
    
    fhm.l <- fhm %>% mutate(Statistikdatum=as.Date(Statistikdatum)) %>%
      select(-c(Antal_avlidna, Antal_intensivvardade, 
                Kumulativa_fall, Kumulativa_avlidna, 
                Kumulativa_intensivvardade,
                Totalt_antal_fall))
    
    fhm.l <- fhm.l%>% #filter(Statistikdatum > "2021-01-01") %>%
      select(c(Statistikdatum, input$region)) %>%
      pivot_longer(-c(Statistikdatum),values_to = "cases") %>%
      group_by(name) %>%
      arrange(name, Statistikdatum, .by_group = T) %>%
      mutate(name=as.factor(name)) 
    
    fhm.p <- ggplot(data = fhm.l, 
                    aes(x=Statistikdatum, y=cases, group=name, color=name))+
    geom_point(size=(0.8/length(input$region)))+
    facet_wrap(~name, scales = "free")+
    scale_x_date(#date_breaks = "2 weeks", date_labels = "%W", 
                 limits = input$daterange)+
    theme(legend.position = "none", 
          axis.text.x = element_text(angle = 0, size = 8),
          axis.text.y = element_blank(),
          axis.ticks.y = element_line(size = 0), 
          axis.title = element_blank())

    if(input$smoothing)
      fhm.p <- fhm.p + geom_smooth()
    
    print(fhm.p)
    
  }, height = 700)
  
}