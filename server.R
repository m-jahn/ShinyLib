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
    # coerce to base data.frame
    data %>% ungroup %>% as.data.frame
  })
  
  # GENERIC DATA FILTERING
  data_filt <- reactive({
    
    # filter data set
    data() %>% filter(
      Gene.names %in% filtGenes(),
      condition %in% input$UserDataFilterCond,
      timepoint %in% input$UserDataFilterTime,
      induction %in% input$UserDataFilterInd
    )
  
  })
  
  
  # DYNAMIC BOXES FOR DATA FILTERING
  output$FilterCond <- renderUI({
    selectInput("UserDataFilterCond",
      "Condition:", unique(data()$condition), 
      selected = unique(data()$condition[1]),
      multiple = TRUE)
  })
  
  output$FilterTime <- renderUI({
    selectInput("UserDataFilterTime",
      "Time point:", unique(data()$timepoint), 
      selected = unique(data()$timepoint),
      multiple = TRUE)
  })
  
  output$FilterInd <- renderUI({
    selectInput("UserDataFilterInd",
      "Induction:", unique(data()$induction), 
      selected = unique(data()$induction),
      multiple = TRUE)
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
    else if (input$UserTheme == "ggplot2") custom.ggplot()
    else if (input$UserTheme == "lattice grey") custom.lattice()
    else if (input$UserTheme == "lattice blue") theEconomist.theme()
  })
  
  # select layout
  layout <- reactive({
    if (input$UserPanelLayout == "manual") {
      c(input$UserPanelLayoutCols, input$UserPanelLayoutRows)}
    else NULL
  })
  
  # select grouping variable
  grouping <- reactive({
    if (input$UserGrouping == "none") NULL
    else if(input$UserGrouping == "by cond. variable") input$UserCondVariable
    else if(input$UserGrouping == "by X variable") input$UserXVariable
    else if(input$UserGrouping == "by Y variable") input$UserYVariable
    else gsub("by ", "", input$UserGrouping)
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
  # ***********************************************
  # To control size of the plots, we need to wrap plots
  # into additional renderUI function that can take height argument
  output$dotplot.ui <- renderUI({
    plotOutput("dotplot", height = input$UserPrintHeight, width = input$UserPrintWidth)
  })
  output$heatmap.ui <- renderUI({
    plotOutput("heatmap", height = input$UserPrintHeight, width = input$UserPrintWidth)
  })
  output$fitness.ui <- renderUI({
    plotOutput("fitness", height = input$UserPrintHeight, width = input$UserPrintWidth)
  })
  output$table.ui <- renderUI({
    tableOutput("table")
  })  
  
  # DOT PLOT OF DEPLETION / ENRICHMENT
  # ***********************************************
  output$dotplot <- renderPlot(res = 120, {
    
    # make plot and print
    plot <- plot_dotplot(
      x = input$UserXVariable,
      y = input$UserYVariable,
      cond_var = input$UserCondVariable,
      groups = grouping(),
      data = data_filt(),
      logfun = logfun,
      theme = theme(),
      layout = layout(),
      type = type(),
      input = input
    )
    
    # print plot to output panel
    print(plot)
    # download function
    output$UserDownloadDotplot <- getDownload(filename = "dotplot.svg", plot = plot)
  
  })
  

  # PLOT DATA AS HEATMAP WITH LEVELPLOT
  # ***********************************************
  output$heatmap <- renderPlot(res = 120, { 
    
    # make plot and print
    plot <- plot_heatmap(
      x = input$UserXVariable,
      y = input$UserCondVariable,
      z = input$UserYVariable,
      cond_var = grouping(),
      data = data_filt(),
      logfun = logfun,
      theme = theme(),
      layout = layout(),
      input = input
    )
    
    print(plot)
    # download function
    output$UserDownloadDotplot <- getDownload(filename = "heatmap.svg", plot = plot)
    
  })
  
  
  # PLOT FITNESS / CORRELATION
  # ***********************************************
  output$fitness <- renderPlot(res = 120, { 
    
    # make plot and print
    plot <- plot_fitness(
      x = "sgRNA_short",
      y = "fitness_score",
      cond_var = "condition",
      groups = grouping(),
      data = filter(data_filt(), timepoint == 0) %>% 
        select_at(vars(c("sgRNA_short", "sgRNA_index", "locus", 
          "fitness_score", "condition", "induction", "Pathway", grouping()))),
      logfun = logfun,
      theme = theme(),
      layout = layout(),
      type = type(),
      input = input
    )
    
    print(plot)
    # download function
    output$UserDownloadFitness <- getDownload(filename = "fitness.svg", plot = plot)
    
  })
  
  
  # RENDER TABLE WITH QUANTITIES OF SELECTED PROTEINS
  # ***********************************************
  output$table <- renderTable(digits = 4, {
    
    # download handler for table
    output$UserDownloadTable <- downloadHandler(
      filename = "data.csv",
      content = function(file) {
        write.csv(data_filt(), file)
      },
      contentType = "text/csv"
    )
    
    # call table to be rendered
    data_filt()
    
  })
  
}