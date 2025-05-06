#' @title Exporting normalized data
#' @description \code{spdg_plotdata_export} exports normalized concentration data.
#'
#' @importFrom dplyr select
#' @importFrom dplyr all_of
#' @importFrom utils write.table
#'
#' @param PlotElements (vector; chr) elements for which you want to plot concentrations
#' @param DataElements (vector; chr) elements presented in the input dataset
#' @param Concentrations (dataframe; chr) concentrations (in µg/g or ppm) in the input dataset.
#' Note that each value in the matrix will be internally converted into the numeric type.
#' Any unreasonable values (e.g., those with '<' below detection limit) will be
#' replaced by NA and will not appear on the plot.
#'
#' @param Filt (List of 2) filter you can generate by using spdg_filter_make().
#' @param Nml (dataframe; num) normalized factors. This package allows you to use
#'  either of PM_MS95' (primitive mantle; McDonough & Sun 1995), 'CI_MS95'
#'  (CI chondrite; McDonough & Sun 1995), and 'NMORB_SM89' (N-MORB; Sun & McDonough 1989).
#'  However, you can set any normalized factors by defining a new 1 x n dataframe.
#' @param Output (logical) if Output = TRUE, normalized concentration data will be
#' exported as a .txt file in the working directory.
#'
#' @return Normalized concentration data
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
#' Concentrations <- data[,4:ncol(data)]
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
#' ProcessedData <- spdg_plotdata_export(
#'   PlotElements, DataElements, Concentrations,
#'   filtering, NMORB_SM89, Output = FALSE
#'   )
#'
#
spdg_plotdata_export <- function(PlotElements, DataElements, Concentrations, Filt, Nml, Output = FALSE){

  if (all(PlotElements %in% colnames(Nml)) == F) {
    stop(cat("Error: Unexpected element(s) in the 'PlotElements' vector \n"))
  }

  #if (all(sapply(Concentrations, class) == "numeric") == F) {
  #  stop(cat("Error: 'Concentrations' should be a numeric type dataframe \n"))
  #}


  DataElements_mod <- DataElements
  Concentrations_mod <- as.data.frame(apply(Concentrations, c(1,2), as.numeric))

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

  if (Output == T) {
    write.table(plotdata[Filt[[1]],], file = paste("Output",deparse(substitute(Nml)), "Normalized.txt"))
  }

  cat(paste("Filter:\nSample Phase Comment1 Comment2\n------------------------------\n", Filt[[2]], "\n"))

  return(plotdata[Filt[[1]],])

}
