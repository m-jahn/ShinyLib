library(shiny)
library(dplyr)
library(ggplot2)
library(lattice)

ui <- fluidPage(

  tags$head(tags$style('
     #my_tooltip {
      position: absolute;
      width: 300px;
      z-index: 100;
     }
  ')),
  tags$script('
    $(document).ready(function(){
      // id of the plot
      $("#plot1").mousemove(function(e){ 

        // ID of uiOutput
        $("#my_tooltip").show();         
        $("#my_tooltip").css({             
          top: (e.pageY + 5) + "px",             
          left: (e.pageX + 5) + "px"         
        });     
      });     
    });
  '),

  plotOutput("plot1", hover = hoverOpts(id = "plot_hover", delay = 100)),
  uiOutput("my_tooltip")
)

server <- function(input, output) {

  data <- reactive({
    mtcars %>% mutate(model = rownames(mtcars))
  })

  output$plot1 <- renderPlot({
    
    ggplot(data(), aes(mpg, disp)) + geom_point() + theme_bw()

  })

  output$my_tooltip <- renderUI({
    df <- nearPoints(data(), input$plot_hover)
    req(nrow(df) != 0)
    verbatimTextOutput("vals")
  })
  
  output$vals <- renderPrint({
    nearPoints(data(), input$plot_hover)[["model"]]
  })
}

shinyApp(ui = ui, server = server)