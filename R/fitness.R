# PLOT CORRELATION BETWEEN 2 CONDITIONS
#
plot_fitness <- function(
  x, y, cond_var, groups, data,
  logfun, theme, layout, type, input
) {
  
  if (!is.null(groups)) {
    # determine number of columns for group legend
    if (length(unique(data[[groups]])) <= 20) {
      ncol_legend <- length(unique(data[[groups]])) %>%
        replace(., . > 4, 4)
    } else {
      ncol_legend <- NULL
    }
  } else {
    ncol_legend <- NULL
  }
  
  # determine number of different conditions
  conditions <- unique(data[[cond_var]])
  
  # histogram of gene fitness if only 1 cond selected
  if (length(conditions) == 1) {
    
    densityplot(
      ~ get(y),
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
        panel.abline(v = 0, lty = 2, lwd = 2, col = grey(0.6))
        panel.densityplot(x, lwd = 2, ...)
      }
    )
    
  } else if (length(conditions) == 2) {
    
    # spread data condition wise
    if (cond_var %in% colnames(data) &
        groups != cond_var) {
      
      xyplot(get(conditions[1]) ~ get(conditions[2]),
        spread(data, get(cond_var), get(y)),
        groups = {if (is.null(groups)) NULL else factor(get(groups))},
        par.settings = theme,
        layout = layout,
        as.table = TRUE,
        scales = list(alternating = FALSE),
        xlab = paste0("fitness - ", conditions[1]), 
        ylab = paste0("fitness - ", conditions[2]),
        auto.key = {if (is.null(ncol_legend)) NULL else list(columns = ncol_legend)},
        panel = function(x, y, ...) {
          panel.grid(h = -1, v = -1,
            col = ifelse(theme == "ggplot2", "white", grey(0.9)))
          panel.abline(h = 0, v = 0, lty = 2, lwd = 2, col = grey(0.6))
          panel.abline(coef = c(0, 1), lty = 2, lwd = 2, col = grey(0.6))
          panel.xyplot(x, y, ...)
        }
      )
      
    } else {
      stop("'condition' should not be the grouping variable, 
        or the chosen condition is not present in the data.")
    }
    
  } else {
    stop("please select only 1 or 2 conditions to compare fitness.")
  }
}
