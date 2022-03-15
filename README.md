
# Revticulate
##  An R package for interacting with RevBayes from R and RStudio

# Installation

Revticulate can be installed in two ways.
The first is via CRAN, using the default `install.packages` function in R:

```{r}
install.packages("Revticulate")
```

The second is via the remotes package, a lightweight package enabling installation from GitHub repositories.

```{r}
remotes::install_github("revbayes/Revticulate")
```

 The GitHub repository for Revticulate contains cutting-edge features and may contain bugfixes, but the CRAN is known to be stable for everyday use.

Upon first installation, Revticulate will run a package check.  
This check searches for and .Renviron file that contains a RevBayes path. If the package doesn’t find this file, or finds it without the path, the package prompts the user to use `usethis::edit_r_environ()`. This opens the .Renviron file, and the user will enter `rb={absolute path to revbayes}`. This can be edited at any time if there are multiple installs on the system, or if you recompile RevBayes and want to use a new version.

Before using Revticulate in knitr, make sure the following is in your setup chunk:

```
library(Revticulate)
knitRev()
```

## Using RevBayes in a KnitR Chunk

RevBayes can be used in a KnitR chunk by changing the header to `rb` instead of `r`. In the below chunk, we create an object called `example` and use the assignment operator to give it the value 1. Then we print it.
```
example <- 1.0
example
```

This is not an overtly useful thing to do, however. Let's erase the previous chunk using the `clearRev()` function. This removes prior code from the RevBayes environment. Very handy if you make a mistake!

```
clearRev()
```

We could, instead, choose to do something a little more useful. How about reading in a data matrix and making a quick starting tree?

```
morpho <- readDiscreteCharacterData("bears.nex")
num_taxa <- morpho.size()
num_branches <- 2 * num_taxa - 2
taxa <- morpho.names()
br_len_lambda ~ dnExp(0.2)
phylogeny ~ dnUniformTopologyBranchLength(taxa, branchLengthDistribution=dnExponential(br_len_lambda))
phylogeny
```
Anything entered in an `rb` block will be interpreted as Rev code, and all the normal Rev syntax will apply. For a nice overview of Rev language and syntax, please see [this tutorial](https://revbayes.github.io/tutorials/intro/rev).

One thing researchers are often interested in doing is making an object in Rev and then viewing it in R. The best way to accomplish this is with the `doRev()` function. When using this function, the RevCode you'd like to run goes in the parentheses of the `doRev` function. These are then exportable to R. In this example, we load the dataset used in the published tutorial "Estimating a time-calibrated phylogeny of fossil and extant taxa using RevBayes" {@barido2020estimating}.
```
doRev(input = 'morpho <- readDiscreteCharacterData("bears.nex")
num_taxa <- morpho.size()
num_branches <- 2 * num_taxa - 2
taxa <- morpho.names()
br_len_lambda ~ dnExp(0.2)
phylogeny ~ dnUniformTopologyBranchLength(taxa, branchLengthDistribution=dnExponential(br_len_lambda))
phylogeny')
```

The `doRev` function is then used to extract the object. Note that knitr chunks can only have one language type. Thus, to use a Rev Object in another chunk, it must be exported. In this case, a phylogeny is not a simple numeric type, and Revticualte automates the coercion from a string to a Newick tree that can be read by Phytools or similar.

```
phylogeny <- doRev("phylogeny")

phytools::plotTree(phylogeny)
```


We may choose to clear RevBayes objects out of memory so that they are not being consistently echoed to the screen.

```

clearRev()

```


One nice facet of having RevBayes running in an R notebook is the ability to flip to visualizations of the different distributions we use. For example, here is the code for a common parameterization of the discrete Gamma distribution on site rates.

```
alpha_morpho ~ dnUniform( 0, 1E6 );
rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )
alpha_morpho
```

If you aren't a big stats person, this might not mean much to you, in terms of what this distribution actually looks like. But it is important to develop intuitions for what common distributions look like and what this says about our data. So, we can use R's built-in graphics capabilities to have a look at what 1000 draws from this gamma will look like.

```
doRev('alpha_morpho ~ dnUniform( 0, 1E6 );
rates_morpho := fnDiscretizeGamma( alpha_morpho, alpha_morpho, 4 )
')

library(ggplot2)
alpha_value <- doRev("alpha_morpho")
alpha_value

draws <- rgamma(1000, shape = alpha_value, rate = alpha_value)
hist(draws, xlab = "Value")
```



### Simulate coin flips

It's adviseable if you're switching gears to a new activity to clear the Rev environment of workspace objects from old activities:

```

clearRev()
```


Note that `clearRev` is an R function, and must be executed in an R chunk.

```
# The number of coin flips
n <- 100

# The number of heads
x <- 50
x
```

### Initialize Markov Chain
We have to start MCMC off with some initial parameter values. One way to do this is to randomly draw values of the parameter ($p$) from the prior distribution. We assume a flat beta prior distribution ($\alpha = 1$ and $\beta = 1$).

```
alpha <- 1
beta <- 1
p <- rbeta (n=1, alpha, beta) [1]
p
```

### Likelihood Function
We next specify the likelihood function. We use the binomial probability for the likelihood function. Since the likelihood is defined only for $p$ between 0 and 1, we return 0 if $p$ is outside this range.

```{rb include=FALSE}
function likelihood(p) {
    if(p < 0 || p > 1)
        return 0
    l<-dbinomial(x,p,n,log=false)
    return l
}
```

The function can then be executed in the next cell:

```
likelihood(p)

```

## The RepRev() environment

The function `repRev()` can be called in the console (or in non-RStudio versions of R) to use RevBayes directly to program interactively. The `repRev()` environment is denoted with `rb>>>`. To exit, type Ctrl + C. It is not compatible with KnitR, being a console tool.

```

# repRev()

# rb>>> 1+2

# [1] 3
```

## Running Long Computations

Perhaps we would like to run a longer computation from R using Revticulate. For example, maybe we have made an MCMC script, and would like to run it using Revticulate, and then automatically process the output in R. In the below example, we will run an MCMC and automatically evaluate it for convergence using the package conveience.

Included with the package, we have a script called 'mcmc_mk.Rev,' which runs a short phylogenetic estimation for a small morphological dataset from bears using the Mk model {@Lewis2001}. Once the computation is complete, convergence is diagnosed with the R package convenience {@fabreti2021}. Please note that this will take about 5 minutes if executed.

```
library(convenience)
callRevFromTerminal("mcmc_mk.Rev")
checkConvergence(path = "vignettes/output/")
```
