#' @title Defining filters for plotting spider diagrams
#' @description \code{spdg_filter_make} defines filters for plotting spider diagrams.
#' You can set at most 4 different factors for the filtering.
#' This function can generate a filter with which all the conditions of
#' Sample = Sample_value, Phase = Phase_value, Comment1 = Comment1_value,
#' Comment2 = Comment2_value are satisfied. (If you set each 'xxx_value' as NA,
#' filtering will not be applied.)
#'
#' @param Sample (dataframe; chr) column for rock sample names
#' @param Phase (dataframe; chr) column for mineral names
#' @param Comment1 (dataframe; chr) column for miscellaneous comments (1)
#' @param Comment2 (dataframe; chr) column for miscellaneous comments (2)
#' @param Sample_value (chr) rock sample name you want to choose
#' @param Phase_value (chr) mineral name you want to choose
#' @param Comment1_value (chr) comment you want to choose (1)
#' @param Comment2_value (chr) comment you want to choose (2)
#'
#' @return List of 2: (1) all the row indexes under which data passing the filters (as a num vector) and (2) filter description (as a text)
#' @export
#' @examples
#' data <- spdgmake_testdata
#' Sample <- as.data.frame(data[,"Type"])
#' Phase <- as.data.frame(data[,"Type"])
#' Comment1 <- as.data.frame(data[,"Type"])
#' Comment2 <- as.data.frame(data[,"Type"])
#' filtering <- spdg_filter_make(Sample, Phase, Comment1, Comment2, NA, NA, NA, NA)
#'
#'
spdg_filter_make <- function(Sample, Phase, Comment1, Comment2, Sample_value = NA, Phase_value = NA, Comment1_value = NA, Comment2_value = NA){

  Merged <- data.frame(Sample,Phase,Comment1, Comment2)



  if(is.na(Sample_value)){
    Sample_Number <- seq(1, nrow(Sample), by = 1)
    Sample_label <- "(all)"
  }else{
    Sample_Number <- grep(Sample_value, Merged[,1], fixed = TRUE)
    Sample_label <- Sample_value
  }

  if(is.na(Phase_value)){
    Phase_Number <- seq(1, nrow(Phase), by = 1)
    Phase_label <- "(all)"
  }else{
    Phase_Number <- grep(Phase_value, Merged[,2], fixed = TRUE)
    Phase_label <- Phase_value
  }

  if(is.na(Comment1_value)){
    Comment1_Number <- seq(1, nrow(Comment1), by = 1)
    Comment1_label <- "(all)"
  }else{
    Comment1_Number <- grep(Comment1_value, Merged[,3], fixed = TRUE)
    Comment1_label <- Comment1_value
  }

  if(is.na(Comment2_value)){
    Comment2_Number <- seq(1, nrow(Comment2), by = 1)
    Comment2_label <- "(all)"
  }else{
    Comment2_Number <- grep(Comment2_value, Merged[,4], fixed = TRUE)
    Comment2_label <- Comment2_value
  }

  AllTrue <- intersect(intersect(Sample_Number,Phase_Number), intersect(Comment1_Number, Comment2_Number))
  MergedLabel <- paste(Sample_label,Phase_label,Comment1_label,Comment2_label)

  return(list(AllTrue, MergedLabel))

}
