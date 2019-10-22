# PLOT DATA AS HEATMAP WITH LEVELPLOT
# some options for dotplot do not apply here
plot_heatmap <- function(
  x, y, z, cond_var, data,
  logfun, theme, layout, input
) {
  
  if (is.null(cond_var)) {
    
    # plot heat map without conditioning
    levelplot(
      logfun(get(z)) ~ factor(get(x)) * factor(get(y)),
      data,
      par.settings = theme, 
      layout = layout,
      as.table = TRUE,
      scales = list (alternating = FALSE),
      xlab = x,
      ylab = z
    )
    
  } else {
    
    # in the rare case we condition by Y variable
    # we have to add a binned pseudo Y variable
    if (cond_var == input$UserYVariable) {
      data <- mutate(data,
        binned_Y = get(cond_var) %>% logfun %>% .bincode(., pretty(.)))
      cond_var <- "binned_Y"
    }
    
    # plot heat map with conditioning
    levelplot(
      logfun(get(z)) ~ factor(get(x)) * factor(get(y)) | factor(get(cond_var)),
      data,
      par.settings = theme, 
      layout = layout,
      as.table = TRUE,
      scales = list (alternating = FALSE),
      xlab = x,
      ylab = z
    )
    
  }
  
}

