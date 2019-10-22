# PLOT DATA AS DOTPLOT
#
plot_dotplot <- function(
  x, y, cond_var, groups, data,
  logfun, theme, layout, type, input
) {
  
  
  if (!is.null(groups)) {
    
    # in the rare case we group by Y variable
    # we have to add a binned pseudo Y variable
    if (groups == input$UserYVariable) {
      data <- mutate(data,
        binned_Y = get(groups) %>% logfun %>% .bincode(., pretty(.)))
      groups <- "binned_Y"
    }
    
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
  
  # rotate X scale if too long
  rot_X_label <- ifelse(
    median(nchar(data[[x]]), na.rm = TRUE) >= 4, 35, 0
  )
  
  # make dot plot
  xyplot(
    logfun(get(y)) ~ factor(get(x)) | factor(get(cond_var)),
    data,
    groups = {if (is.null(groups)) NULL else factor(get(groups))},
    par.settings = theme, 
    layout = layout,
    as.table = TRUE,
    scales = list(alternating = FALSE, x = list(rot = rot_X_label)),
    xlab = x, ylab = paste0(y, " (", input$UserLogY, ")"), 
    type = "l", 
    auto.key = {if (is.null(ncol_legend)) NULL else list(columns = ncol_legend)},
    panel = function(x, y, subscripts = NULL, groups = NULL, ...) {
      panel.grid(h = -1, v = -1, 
        col = ifelse(theme == "ggplot2", "white", grey(0.9)))
      if (type %in% c("p", "b"))
        panel.xyplot(x, y, subscripts = subscripts, groups = groups, type = "p")
      panel.superpose(x, y, subscripts = subscripts, groups = groups, ...)
    }, panel.groups = function(x, y, ...) {
      if (type %in% c("l", "b")) {
        panel.xyplot(unique(x), 
          tapply(y, x, function(x) mean(x, na.rm = TRUE)), ...)
      }
    } 
  )
  
}
