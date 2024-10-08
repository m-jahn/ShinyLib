#' Custom ggplot2 like theme
#' 
#' Custom themes for lattice plots
#' 
#' @import colorspace
#' @import lattice
#' @import latticeExtra
#' @export
# ------------------------------------------------------------------------------
custom.ggplot <- function(n_colors = 9) {
  theme <- latticeExtra::ggplot2like(n = n_colors)
  theme$axis.line$col <- "white"
  theme$axis.line$lwd <- 2
  theme$strip.border$col <- "white"
  theme$strip.border$lwd <- 2
  theme
}

#' Custom grey lattice theme
#' 
#' Custom themes for lattice plots
#' 
#' @export
# ------------------------------------------------------------------------------
custom.lattice <- function(n_colors = 9) {
  gradient <- colorRampPalette(colors =
    c("#5E4FA2", "#3288BD", "#66C2A5", "#ABDDA4", "#E6F598",
      "#FDAE61", "#F46D43", "#D53E4F", "#9E0142"
    ))(n_colors)
  theme <- latticeExtra::custom.theme(
    symbol = gradient,
    fill = gradient,
    region = gradient,
    reference = 1, bg = 0, fg = 1)
  theme$superpose.symbol$pch <- 19
  theme$superpose.symbol$cex <- 0.7
  theme$superpose.line$lwd <- 2
  theme$plot.symbol$pch <- 19
  theme$plot.symbol$cex <- 0.7
  theme$plot.line$lwd <- 2
  theme$strip.background$col <- c(grey(0.95), grey(0.85))
  theme$strip.shingle$col <- c(grey(0.75), grey(0.65))
  theme$reference.line$col <- grey(0.4)
  theme$add.line$col <- grey(0.4)
  theme$add.text$cex <- 0.8
  theme$par.main.text$cex <- 1
  theme$box.umbrella$lty <- 1
  theme$par.main.text$font <- 1
  theme
}
