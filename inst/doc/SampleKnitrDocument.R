## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, eval=FALSE)

## -----------------------------------------------------------------------------
#  library(Revticulate)
#  initRev("/Users/april/software/rb")
#  knitRev()

## -----------------------------------------------------------------------------
#  phylogeny <- getRevObj(name = "phylogeny", coerce = TRUE)
#  
#  phytools::plotTree(phylogeny)

## -----------------------------------------------------------------------------
#  doRev('
#  alpha_morpho ~ dnUniform( 0, 1E6 );
#  rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )
#  ')
#  
#  library(ggplot2)
#  alpha_value <- getRevObj(name = "alpha_morpho", coerce = TRUE)
#  alpha_value
#  
#  draws <- rgamma(1000, shape = alpha_value, rate = alpha_value)
#  hist(draws, xlab = "Value")

