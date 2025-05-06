#' @title Generating the plot area for spider diagrams
#' @description \code{spdg_plot} generates the plot area for spider diagrams
#'
#' @param PlotElements Sample
#' @param Order_min Sample
#' @param Order_max Sample
#' @param Xlabelsize Sample
#'
#'
#' @export
#' @examples
#' library(spdgmake)
#' PlotElements <- c(
#'   "Cs", "Rb","Ba", "Pb", "Sr","La","Nd","Sm","Eu","Gd",
#'   "Dy","Yb","Lu","Hf","Ta","Y","Zr","Nb","Th","U"
#'   )
#' spdg_plot(PlotElements, -3, 3, 0.85)
#'
spdg_plot <- function(PlotElements, Order_min = -3, Order_max = 3, Xlabelsize = 0.85){


  p <- c(1, length(PlotElements))

  q <- c(10^(Order_min), 10^(Order_max))
  plot(p, q, xaxt = "n", log = "y", ylim = c(10^(Order_min),
                                             10^(Order_max)), xlab = "", ylab = "",
       las = 1, type = "n")
  axis(1, at = 1:length(PlotElements), labels = PlotElements, cex.axis = Xlabelsize)

}
