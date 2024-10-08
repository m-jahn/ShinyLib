# 
# SHINY SERVER
# ***********************************************
server <- function(input, output) {
  
  # MAIN DATA IS LOADED
  # the reactive environment makes sure all widgets can use the data
  # without re-reading every time
  data <- reactive({
    
    # read user selected data set
    get(input$UserDataChoice) %>%
      # coerce to base data.frame
      ungroup %>% as.data.frame
  })
  
  # GENERIC DATA FILTERING
  data_filt <- reactive({
    # filter data set by gene selection
    data <- data() %>% filter(get(config()$tree$gene_level) %in% filtGenes())
    # filter data set by user input
    for (filt in names(config()$data)) {
      data <- filter(data, get(filt) %in% input[[paste0("Filter_", filt)]])
    }
    data
  })
  
  # GET GLOBAL CONFIGURATION FOR CHOSEN DATASET
  config <- reactive({data_config[[input$UserDataChoice]]})
  
  # DYNAMIC BOXES FOR DATA FILTERING
  output$UserFilters <- renderUI({
    lapply(names(config()$data), function(filt) {
      selectInput(
        inputId = paste0("Filter_", filt),
        label = paste0(filt, ":"),
        choices = config()$data[[filt]]$values,
        selected = config()$data[[filt]]$selected,
        multiple = TRUE)
    })
  })
  
  # DYNAMIC BOXES FOR DATA VIZ OPTIONS
  output$UserXVariable <- renderUI({
    selectInput("UserXVariable", 
      "X variable:", config()$plotting$x_vars,
      selected = config()$plotting$x_vars[1])
  })
  
  output$UserYVariable <- renderUI({
    selectInput("UserYVariable", 
      "Y variable:", config()$plotting$y_vars,
      selected = config()$plotting$y_vars[1])
  })
  
  output$UserCondVariable <- renderUI({
    selectInput("UserCondVariable", 
      "Conditioning variable:", config()$plotting$cond_vars,
      selected = config()$plotting$cond_vars[1])
  })
  
  output$UserTheme <- renderUI({
    selectInput("UserTheme", 
      "Theme:", config()$default$theme,
      selected = config()$default$theme[1])
  })
  
  output$UserGrouping <- renderUI({
    selectInput("UserGrouping", 
      "Grouping:", config()$default$grouping,
      selected = config()$default$grouping[1])
  })
  
  output$UserPlotType <- renderUI({
    selectInput("UserPlotType", 
      "Plot type:", config()$default$plot_type,
      selected = config()$default$plot_type[1])
  })
  
  output$UserLogY <- renderUI({
    selectInput("UserLogY", 
      "Y scale:", config()$default$y_scale,
      selected = config()$default$y_scale[1])
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
    #n_groups <- length(unique(data_filt()[[grouping()]]))
    n_groups = 9
    if (input$UserTheme == "ggplot1") ggplot2like(n = n_groups)
    else if (input$UserTheme == "ggplot2") custom.ggplot(n_groups)
    else if (input$UserTheme == "lattice grey") custom.lattice(n_groups)
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
     
    # remove duplicated proteins
    prot <- filter(data(), !duplicated(get(config()$tree$gene_level))) %>%
      # select columns for construction of tree
      select(all_of(config()$tree$levels))
    
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
    output$UserDownloadHeat <- getDownload(filename = "heatmap.svg", plot = plot)
    
  })
  
  
  # PLOT FITNESS / CORRELATION
  # ***********************************************
  output$fitness <- renderPlot(res = 120, {
    
    # make plot and print
    plot <- plot_fitness(
      x_var = config()$default$fitness$x_var,
      y_var = config()$default$fitness$y_var,
      comparison = config()$default$fitness$comparison,
      groups = grouping(),
      data = filter(data_filt(),
        get(config()$default$fitness$filter$var) == config()$default$fitness$filter$val),
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