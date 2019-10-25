library(shiny)
library(dplyr)
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
    mtcars <- mtcars %>% mutate(model = rownames(mtcars))
    print(mtcars)
    mtcars
  })

  output$plot1 <- renderPlot({
    
    xyplot(mpg ~ disp, data())
    
  })

  output$my_tooltip <- renderUI({
    hover <- input$plot_hover
    data <- mutate_at(data(), vars("mpg", "disp"),
      function(x) scales::rescale(x, to = c(-0.04, 1.04))
    )
    y <- nearPoints(data, hover, xvar = "mpg", threshold = 20, yvar = "disp")[ , c("mpg", "disp")]
    req(nrow(y) != 0)
    verbatimTextOutput("vals")
  })

  output$vals <- renderPrint({
    hover <- input$plot_hover
    data <- mutate_at(data(), vars("mpg", "disp"),
      function(x) scales::rescale(x, to = c(-0.04, 1.04))
    )
    data$model <- rownames(data)
    res <- nearPoints(data, hover, xvar = "mpg", threshold = 20, yvar = "disp")[ , "model"]
    res
  })
}
shinyApp(ui = ui, server = server)