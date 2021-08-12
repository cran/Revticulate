## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, eval=FALSE)

## -----------------------------------------------------------------------------
#  library(Revticulate)
#  initRev("/Users/april/software/rb")
#  knitRev()

## ---- eval=FALSE, include=FALSE-----------------------------------------------
#  devtools::install_github("paleantology/Revticulate")

## -----------------------------------------------------------------------------
#  clearRev()

## -----------------------------------------------------------------------------
#  doRev(input = 'morpho <- readDiscreteCharacterData("Cinctans.nex")
#  num_taxa <- morpho.size()
#  num_branches <- 2 * num_taxa - 2
#  taxa <- morpho.names()
#  br_len_lambda ~ dnExp(0.2)
#  phylogeny ~ dnUniformTopologyBranchLength(taxa, branchLengthDistribution=dnExponential(br_len_lambda))
#  phylogeny')

## -----------------------------------------------------------------------------
#  phylogeny <- getRevObj(name = "phylogeny", coerce = TRUE)
#  
#  phytools::plotTree(phylogeny)

## -----------------------------------------------------------------------------
#  
#  clearRev()
#  

## -----------------------------------------------------------------------------
#  doRev('alpha_morpho ~ dnUniform( 0, 1E6 );
#  rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )
#  ')
#  
#  library(ggplot2)
#  alpha_value <- getRevObj(name = "alpha_morpho", coerce = TRUE)
#  alpha_value
#  
#  draws <- rgamma(1000, shape = alpha_value, rate = alpha_value)
#  hist(draws, xlab = "Value")

## -----------------------------------------------------------------------------
#  
#  clearRev()

## -----------------------------------------------------------------------------
#  
#  # repRev()
#  
#  # rb>>> 1+2
#  
#  # [1] 3

