
# spdgmake

<!-- badges: start -->
<!-- badges: end -->

spdgmake is a tool for plotting spider diagrams used in geochemistry.

## Installation

You can install this package from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Ryo-fkushima/spdgmake")
```

## Example

``` r
library(spdgmake)

# load concentration data
data <- spdgmake_testdata

# define concentration matrix (as a numeric type dataframe)
Concentrations_original <- data[,4:ncol(data)]
Concentrations <- as.data.frame(apply(Concentrations_original, c(1,2), as.numeric))

# define the element list presented in the input data
DataElements <- colnames(data)[4:ncol(data)]

# set the element list whose concentrations you want to plot
PlotElements <- c("Cs", "Rb","Ba", "Pb", "Sr","La","Nd","Sm","Eu","Gd","Dy","Yb","Lu","Hf","Ta","Y","Zr","Nb","Th","U")

# generate the plot area
spdg_plot(PlotElements, -3, 3, 0.85)


# define the filter
Sample <- as.data.frame(data[,"Type"])
Phase <- as.data.frame(data[,"Type"])
Comment1 <- as.data.frame(data[,"Type"])
Comment2 <- as.data.frame(data[,"Type"])

filtering <- spdg_filter_make(Sample, Phase, Comment1, Comment2, NA, NA, NA, NA)

# draw spider diagrams
spdg_lines(PlotElements, DataElements, Concentrations, filtering, NMORB_SM89, "black")

# save processed data
# ProcessedData <- spdg_plotdata_export(PlotElements, DataElements, Concentrations, filtering, NMORB_SM89, Output = FALSE)

```

