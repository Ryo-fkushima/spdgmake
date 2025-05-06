#' @title Drawing spider diagrams
#' @description \code{spdg_lines} draws spider diagrams.
#' Use this function after making a plot area with the spdg_plot() function and
#' generating the filter with the spdg_filter_make() function.
#'
#' @importFrom dplyr select
#' @importFrom dplyr all_of
#' @importFrom graphics lines
#' @importFrom graphics title
#'
#' @param PlotElements (vector; chr) elements for which you want to plot concentrations
#' @param DataElements (vector; chr) elements presented in the input dataset
#' @param Concentrations (dataframe; num) concentrations (in µg/g or ppm) in the input dataset.
#' Note that each value in the dataframe should be a numeric type value.
#' NA values can be read but will not appear on the plot.
#'
#' @param Filt (List of 2) filter you can generate by using spdg_filter_make().
#' @param Nml (dataframe; num) normalized factors. This package allows you to use
#'  either of PM_MS95' (primitive mantle; McDonough & Sun 1995), 'CI_MS95'
#'  (CI chondrite; McDonough & Sun 1995), and 'NMORB_SM89' (N-MORB; Sun & McDonough 1989).
#'  However, you can set any normalized factors by defining a new 1 x n dataframe.
#'
#' @param Plotcolor (chr) line color
#' @param Plottype (chr) type as in the lines() function
#' @param Symboltype (int) pch as in the lines() function
#' @param Linetype (int) lty as in the lines() function
#' @param Width (num) lwd as in the lines() function
#'
#' @export
#' @examples
#' data <- spdgmake_testdata
#'
#' Sample <- as.data.frame(data[,"Type"])
#' Phase <- as.data.frame(data[,"Type"])
#' Comment1 <- as.data.frame(data[,"Type"])
#' Comment2 <- as.data.frame(data[,"Type"])
#'
#' DataElements <- colnames(data)[4:ncol(data)]
#'
#' Concentrations_original <- data[,4:ncol(data)]
#' Concentrations <- as.data.frame(apply(Concentrations_original, c(1,2), as.numeric))
#'
#' PlotElements <- c(
#'   "Cs", "Rb","Ba", "Pb", "Sr","La","Nd","Sm","Eu","Gd",
#'   "Dy","Yb","Lu","Hf","Ta","Y","Zr","Nb","Th","U"
#'   )
#'
#' spdg_plot(PlotElements, -3, 3, 0.85)
#'
#' filtering <- spdg_filter_make(Sample, Phase, Comment1, Comment2, NA, NA, NA, NA)
#'
#' spdg_lines(PlotElements, DataElements, Concentrations, filtering, NMORB_SM89, "black")
#'
#'
spdg_lines <- function(PlotElements, DataElements, Concentrations, Filt, Nml, Plotcolor = "black", Plottype = "l", Symboltype = 20, Linetype = 1, Width = 1){

if (all(PlotElements %in% colnames(Nml)) == F) {
  stop(cat("Error: Unexpected element(s) in the 'PlotElements' vector \n"))
}

 if (all(sapply(Concentrations, class) == "numeric") == F) {
   stop(cat("Error: 'Concentrations' should be a numeric type dataframe \n"))
 }


DataElements_mod <- DataElements
#Concentrations_mod <- as.data.frame(apply(Concentrations, c(1,2), as.numeric))
Concentrations_mod <- Concentrations

for (i in 1:length(PlotElements)) {
  if (PlotElements[i] %in% DataElements_mod) {
  }
  else {
    DataElements_mod <- append(DataElements_mod, PlotElements[i])
    Concentrations_mod <- cbind.data.frame(Concentrations_mod, numeric(nrow(Concentrations_mod)))
  }
}

colnames(Concentrations_mod) <- DataElements_mod

#####

concdata <- dplyr::select(Concentrations_mod, dplyr::all_of(PlotElements))
standard <- dplyr::select(Nml, dplyr::all_of(PlotElements))

concdata[is.na(concdata)] <- 0

plotdata <- concdata

for(i in 1:nrow(plotdata)){
  plotdata[i,] <- concdata[i,] / standard[1,]
}

plotdata[plotdata == 0] <- NA

for (i in Filt[[1]]){
  lines(t(plotdata[i,]), type = Plottype, pch = Symboltype, col = Plotcolor, lwd = Width, lty = Linetype)
}


title(paste(deparse(substitute(Nml)), " normalized"))

return(cat(paste("Normalized data plotted ( n =", length(Filt[[1]]),")\nFilter:\nSample Phase Comment1 Comment2\n------------------------------\n", Filt[[2]], "\n")))

}

