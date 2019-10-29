#
# SHINY UI
# ***********************************************
# Define user interface for application
ui <- navbarPage(
  
  # Title on NavBar Header
  title = "ShinyLib - interactive gene fitness analysis",
  
  # Use one of different shiny themes
  theme = shinytheme("cosmo"),
  #shinythemes::themeSelector(),
  
  tabPanel("App",
    
    # Sidebar
    sidebarLayout(
      
      # HERE COME ALL CONTROLS FOR THE SIDEBAR PANEL
      sidebarPanel(width = 5,
        
        # SELECT DATA
        # -------------------
        # select data file
        h4("DATA OPTIONS"),
        
        fluidRow(
          column(width = 12, 
            selectInput("UserDataChoice",
              "Choose data:", datalistfiles, 
              selected = datalistfiles[1])
          )
        ),
        
        # select additional filters
        fluidRow(
          column(width = 4, 
            uiOutput("FilterCond")
          ),
          column(width = 4,
            uiOutput("FilterTime")
          ),
          column(width = 4,
            uiOutput("FilterInd")
          )
        ),
        
        # SELECT PLOT OPTIONS
        # -------------------
        
        hr(),
        h4("PLOT OPTIONS"),
        fluidRow(
          
          # FACTORIZATION AND ORDERING OPTIONS
          column(width = 4, 
            selectInput("UserXVariable", 
              "X variable:", choices = list("timepoint", "generations", "condition", 
                "induction", "sgRNA_short", "locus", "Protein", "Process","Pathway"),
              selected = "timepoint")
          ),
          column(width = 4, 
            selectInput("UserYVariable", 
              "Y variable:", choices = list("FoldChange", "fitness_score", 
                "baseMean", "padj"),
              selected = "FoldChange")
          ),
          column(width = 4, 
            selectInput("UserCondVariable", 
              "Conditioning variable:", choices = list("timepoint", "generations", "condition", 
                "induction", "sgRNA_short", "locus", "Protein", "Process","Pathway"),
              selected = "sgRNA_short")
          )
        ),
        
        fluidRow(
          
          # DATA GROUPING OPTIONS
          column(width = 3, 
            selectInput("UserTheme", 
              "Theme:", choices = list("lattice grey", "lattice blue", "ggplot1", "ggplot2"),
              selected = "lattice grey")
          ),
          column(width = 3, 
            selectInput("UserGrouping", 
              "Grouping:", choices = list("none", "by cond. variable", "by X variable", 
                "by Y variable", "by condition", "by induction"),
              selected = "by induction")
          ),
          column(width = 3, 
            selectInput("UserPlotType", 
              "Plot type:", choices = list("points", "lines", "points and lines"),
              selected = "points and lines")
          ),
          column(width = 3, 
            selectInput("UserLogY", 
              "Y scale:", choices = list("linear","log 2","log 10", "log e"),
              selected = "log 2")
          )
        ),
        
        # OTHER GRAPHICAL PLOT OPTIONS
        fluidRow(
          
          # PANEL LAYOUT AND PLOT DIMESNIONS
          column(width = 4, 
            selectInput("UserPanelLayout", 
              "Panel layout:", choices = list("automatic", "manual"),
              selected = "automatic")
          ),
          column(width = 2, 
            conditionalPanel(condition = "input.UserPanelLayout == 'manual'",
              numericInput("UserPanelLayoutCols", 
                "Columns:", value = 4)
            )
          ),
          column(width = 2, 
            conditionalPanel(condition = "input.UserPanelLayout == 'manual'",
              numericInput("UserPanelLayoutRows", 
              "Rows:", value = 4)
            )
          ),
          column(width = 2, 
            selectInput("UserPrintHeight",
              "Plot height:", choices = c(1:10*100), selected = 700)
          ),
          column(width = 2, 
            selectInput("UserPrintWidth",
              "Plot width:", choices = c("auto", 1:10*100), selected = "auto")
          )
        ),
        
        hr(),
        fluidRow(
          
          # SELECT GENES OR PROTEINS FROM TREE
          column(width = 6, 
            h4("PROTEIN SELECTION"),
            shinyTree("tree", search = TRUE, checkbox = TRUE)
          ),
          
          # INFO BOX WITH CONTACT AND REFERENCES (EXTERNAL)
          helpbox(width = 6)
          
        )
      ),
      
      
      # MAIN PANEL WITH OUTPUT PLOTS
      # Each tab has individual Download buttons
      column(width = 7,
        wellPanel(
          tabsetPanel(
            tabPanel("DEPLETION / ENRICHMENT", uiOutput("dotplot.ui"),
              downloadButton("UserDownloadDotplot", "Download svg"),
              help_dotplot()
            ),
            tabPanel("HEAT MAP", uiOutput("heatmap.ui"),
              downloadButton("UserDownloadHeat", "Download svg"),
              help_heatmap()
            ),
            tabPanel("FITNESS", uiOutput("fitness.ui"),
              downloadButton("UserDownloadFitness", "Download svg"),
              help_fitness()
            ),
            #tabPanel("CLUSTERING", uiOutput("clustering.ui"),
            #  numericInput("UserNClust", label = "N cluster", value = 4, step = 1)
            #),
            tabPanel("TABLE", uiOutput("table.ui"),
              downloadButton("UserDownloadTable", "Download table")
            )
          )
        )
      )
    )
  ),
  
  # THE ABOUT PAGE
  tabPanel("About", 
    # THE SAME OR A BIT EXTENDED HELP BOX AS IN SIDEBAR
    column(width = 4,
      helpbox(width = 12),
      fundbox(width = 12),
    ),
    column(width = 8,
      methbox(width = 12)
    )
  )

)