#' @title Exporting normalized data
#' @description \code{spdg_plotdata_export} exports normalized data
#'
#' @importFrom dplyr select
#' @param PlotElements Sample
#' @param DataElements Sample
#' @param Concentrations Sample
#' @param Filt Sample
#' @param Nml Sample
#' @param Output Sample
#'
#' @return Normalized concentration data
#' @export
#' @examples
#' library(spdgmake)
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
#' ProcessedData <- spdg_plotdata_export(PlotElements, DataElements, Concentrations, filtering, NMORB_SM89, Output = FALSE)
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

  concdata <- dplyr::select(Concentrations_mod, all_of(PlotElements))
  standard <- dplyr::select(Nml, all_of(PlotElements))

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
