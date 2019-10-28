# PLOT CORRELATION BETWEEN 2 CONDITIONS
#
plot_fitness_interactive <- function(
  x, y, cond_var, groups, data,
  logfun, theme, layout, type, input
) {
  
  # Function for generating tooltip text
  movie_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$sgRNA_short)) return(NULL)

    #all_movies <- isolate(movies())
    #movie <- all_movies[all_movies$ID == x$ID, ]

    paste0("<b>", x$sgRNA_short, "</b><br>",
      "test", "<br>"#,
      #format(movie$BoxOffice, big.mark = ",", scientific = FALSE)
    )
  }
  
  # histogram of gene fitness if only 1 cond selected
  # ggvis(
  #   data = data, ~fitness_score) %>%
  #   #x = prop("x", as.symbol(y))#, 
  #   #fill = ~colors
  #   #) %>% 
  # group_by(~induction) %>%
  # layer_densities()
    
  # spread data condition wise
  if (cond_var %in% colnames(data) &
      groups != cond_var) {
  
    # some inputs are strings, 
    # and need to be converted to ggvis 'properties'
    ggvis(
      data = spread(data, get(cond_var), get(y)), 
      x = prop("x", as.symbol(unique(data[[cond_var]])[1])), 
      y = prop("y", as.symbol(unique(data[[cond_var]])[2]))) %>%
    layer_points(size := 50, size.hover := 200,
      fillOpacity := 0.2, fillOpacity.hover := 0.5,
      key = {if (is.null(groups)) NULL else prop("y", as.symbol(groups))}) %>%
    add_tooltip(movie_tooltip, "hover") %>%
    set_options(
      height = input$UserPrintHeight, 
      width = input$UserPrintWidth, 
      resizable = FALSE)
    # add_axis("x", title = xvar_name) %>%
    # add_axis("y", title = yvar_name) %>%
    # add_legend("stroke", title = "Won Oscar", values = c("Yes", "No")) %>%
    # scale_nominal("stroke", domain = c("Yes", "No"),
    #   range = c("orange", "#aaa"))
  
  } else {
    stop("'condition' should not be the grouping variable, 
      or the chosen condition is not present in the data.")
  }
  
}