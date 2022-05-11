# PLOT CORRELATION BETWEEN 2 CONDITIONS
#
plot_fitness <- function(
  x_var, y_var, comparison, groups, data,
  logfun, theme, layout, type, input
) {
  
  # check that data is loaded
  req(nrow(data) != 0)
  
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
  conditions <- unique(data[[comparison]])
  
  # ignore grouping if condition is chosen
  if (groups == comparison) {
    groups = NULL
  }
  
  # spread data based on condition, merge replicates
  data <- pivot_wider(data, id_cols = all_of(c(x_var, groups)),
    names_from = comparison, values_from = all_of(y_var), values_fn = mean)
  
  # histogram of gene fitness if only 1 cond selected
  if (length(conditions) == 1) {
    
    densityplot(
      ~ get(conditions), data,
      groups = {if (is.null(groups)) NULL else factor(get(groups))},
      par.settings = theme, labels = data[[x_var]],
      layout = layout, as.table = TRUE,
      scales = list(alternating = FALSE),
      xlab = paste0("fitness (", input$UserLogY, ")"), ylab = "density",
      auto.key = {if (is.null(ncol_legend)) NULL else list(columns = ncol_legend)},
      panel = function(x, labels, ...) {
        panel.grid(h = -1, v = -1,
          col = ifelse(grepl("ggplot", input$UserTheme), "white", grey(0.9)))
        panel.abline(v = 0, lty = 2, lwd = 2, col = grey(0.6))
        panel.densityplot(x, lwd = 2, ...)
        latticetools::panel.directlabels(x, rep(0, length(x)), labels = labels,
          positioning = "ggrepel",
          x_boundary = c(-Inf, -2), draw_box = TRUE, cex = 0.5,
          box_fill = grey(0.9, 0.5), box_line = TRUE, ...)
      }
    )
    
  } else if (length(conditions) == 2) {
    
    xyplot(get(conditions[2]) ~ get(conditions[1]), data,
      groups = {if (is.null(groups)) NULL else factor(get(groups))},
      par.settings = theme, labels = data[[x_var]],
      xlab = paste0("fitness - ", conditions[1]),
      ylab = paste0("fitness - ", conditions[2]),
      auto.key = {if (is.null(ncol_legend)) NULL else list(columns = ncol_legend)},
      panel = function(x, y, labels, ...) {
        panel.grid(h = -1, v = -1,
          col = ifelse(theme == "ggplot2", "white", grey(0.9)))
        panel.abline(h = 0, v = 0, lty = 2, lwd = 2, col = grey(0.6))
        panel.abline(coef = c(0, 1), lty = 2, lwd = 2, col = grey(0.6))
        panel.xyplot(x, y, ...)
        latticetools::panel.directlabels(x, y, labels = labels,
          positioning = "ggrepel",
          x_boundary = c(-Inf, -1), y_boundary = c(-Inf, -1),
          draw_box = TRUE, cex = 0.5, box_fill = grey(0.9, 0.5),
          box_line = TRUE, ...)
      }
    )
    
  } else {
    stop("please select only 1 or 2 conditions to compare fitness.")
  }
}
