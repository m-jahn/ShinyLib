# PLOT CORRELATION BETWEEN 2 CONDITIONS
#
plot_fitness <- function(
  x, y, conditions, cond_var, groups, data,
  logfun, theme, layout, type, input
) {
  
  # group by explanatory variable (x, usually genes) and conditions
  data <- data %>% group_by_at(vars(c(x, conditions)))# %>% 
    #slice(1)
  print(head(data))
  
  # dotplot of gene fitness
  # xyplot(
  #   logfun(get(y)) ~ factor(get(x)) | factor(get(cond_var)),
  #   data,
  #   #groups = {if (is.null(groups)) NULL else factor(get(groups))},
  #   par.settings = theme, 
  #   layout = layout,
  #   as.table = TRUE,
  #   scales = list(alternating = FALSE, x = list(rot = rot_X_label)),
  #   xlab = x, ylab = paste0(y, " (", input$UserLogY, ")"), 
  #   type = "l", 
  #   auto.key = {if (is.null(ncol_legend)) NULL else list(columns = ncol_legend)},
  #   panel = function(x, y, subscripts = NULL, groups = NULL, ...) {
  #     panel.grid(h = -1, v = -1, 
  #       col = ifelse(theme == "ggplot2", "white", grey(0.9)))
  #     if (type %in% c("p", "b"))
  #       panel.xyplot(x, y, subscripts = subscripts, groups = groups, type = "p")
  #     panel.superpose(x, y, subscripts = subscripts, groups = groups, ...)
  #   }, panel.groups = function(x, y, ...) {
  #     if (type %in% c("l", "b")) {
  #       panel.xyplot(unique(x), 
  #         tapply(y, x, function(x) mean(x, na.rm = TRUE)), ...)
  #     }
  #   } 
  # )
  
}
