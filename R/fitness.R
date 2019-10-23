# PLOT CORRELATION BETWEEN 2 CONDITIONS
#
plot_fitness <- function(
  x, y, cond_var, groups, data,
  logfun, theme, layout, type, input
) {
  
  # determine number of different conditions
  conditions <- unique(data[[cond_var]])
  
  if (!is.null(groups)) {
    # determine number of columns for group legend
    if (length(unique(data[[groups]])) <= 10) {
      ncol_legend <- length(unique(data[[groups]])) %>%
        replace(., . > 4, 4)
    } else {
      ncol_legend <- NULL
    }
  } else {
    ncol_legend <- NULL
  }
    
  
  # histogram of gene fitness if only 1 cond selected
  if (length(conditions) >= 1) {
    
    densityplot(
      ~ logfun(get(y)),
      data,
      groups = {if (is.null(groups)) NULL else factor(get(groups))},
      par.settings = theme,
      layout = layout,
      as.table = TRUE,
      scales = list(alternating = FALSE),
      xlab = paste0(y, " (", input$UserLogY, ")"), ylab = "density",
      auto.key = {if (is.null(ncol_legend)) NULL else list(columns = ncol_legend)},
      panel = function(x, y, ...) {
        panel.grid(h = -1, v = -1,
          col = ifelse(theme == "ggplot2", "white", grey(0.9)))
        panel.densityplot(x, lwd = 2, ...)
      }
    )
    
  #} else if (length(conditions) > 1) {
    
    
    
  } else NULL
  
  
}
