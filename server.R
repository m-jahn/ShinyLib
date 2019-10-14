# 
# SHINY SERVER
# ***********************************************
server <- function(input, output) {
  
  # MAIN DATA IS LOADED
  # the reactive environment makes sure all widgets can use the data
  # without re-reading every time
  data <- reactive({
    
    # read user selected data set
    load(input$UserDataChoice)
    # optionally filter columns by a set of allowed regular expressions
    data %>% ungroup %>% 
      filter(condition == "L300", timepoint == 8, induction == "i") %>%
      #slice(1:100) %>% 
      as.data.frame
  })
  
  # SOME GLOBAL FUNCTIONS THAT ALL PLOTS USE
  # filter data by user choices
  filtGenes <- reactive({
    get_selected(input$tree, format = "names") %>% 
      unlist
  })
  
  # apply log or lin transformation to orig data
  logfun <- function(x) {
    if (input$UserLogY == "linear") x
    else if(input$UserLogY == "log 2") log2(x)
    else if(input$UserLogY == "log 10") log10(x)
    else log(x)
  }
  
  # select type of plot (points or lines)
  type <- reactive({
    if (input$UserPlotType == "points") "p"
    else if(input$UserPlotType == "lines") "l"
    else if(input$UserPlotType == "points and lines") "b"
  })
  
  # select theme
  theme <- reactive({
    if (input$UserTheme == "ggplot1") ggplot2like()
    else if (input$UserTheme == "ggplot2") custom.ggplot
    else if (input$UserTheme == "lattice grey") custom.lattice
    else if (input$UserTheme == "lattice blue") theEconomist.theme()
  })
  
  # generic download handler for all download buttons
  getDownload <- function(filename, plot) {
    downloadHandler(
      filename = filename,
      content = function(file) {
        svg(file, 
          width = {if (input$UserPrintWidth == "auto") 7
            else as.numeric(input$UserPrintWidth)/100}, 
          height = as.numeric(input$UserPrintHeight)/100)
        print(plot)
        dev.off()
      },
      contentType = "image/svg"
    )
  }
  
  # SHINY TREE
  output$tree <- renderTree({
     
    # select only some columns for construction of tree
    cols <- c("Process.abbr", "Pathway.abbr", "Gene.names", "Protein")
    # remove duplicated proteins
    prot <- data()[!duplicated(data()$Gene.names), cols]
    
    # generate list for tree using this recursive function
    makeTree <-function(rows, col, numcols) {
      if(col == numcols) prot[rows, col] else {
        spl <- split(rows, prot[rows, col])
        lapply(spl, function(rows) makeTree(rows, col+1, numcols))
      }
    }
    
    # apply function to make nested list of the tree
    listTree <- makeTree(seq_len(nrow(prot)), 1, ncol(prot))
    # change attributes of some nodes so that they are selected right from the start
    # if nothing is selected the tree returns NULL
    listTree[[1]][[1]] <- lapply(listTree[[1]][[1]], function(x) {
      attr(x, which = "stselected") <- TRUE; x})
    listTree
  })
  
   
  # PLOT AND TABLE UI OUTPUTS
  #
  # To control size of the plots, we need to wrap plots
  # into additional renderUI function that can take height argument
  output$table.ui <- renderUI({
    tableOutput("table")
  })
  
  
  
  output$table <- renderTable(digits = 4, {
    
    # RENDER TABLE WITH QUANTITIES OF SELECTED PROTEINS
    # ***********************************************
    
    # filter data by user choices
    data <- subset(data(), Gene.names %in% filtGenes())
    
    # download handler for table
    output$UserDownloadTable <- downloadHandler(
      filename = "data.csv",
      content = function(file) {
        write.csv(data, file)
      },
      contentType = "text/csv"
    )
    
    # call table to be rendered
    data
    
    })
  
}