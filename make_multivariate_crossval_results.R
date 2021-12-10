# The preceding script in the "pipeline" is "solvey_US_multivariate.R", which
# conducts a maximum likelihood calculation for both the conditionally
# dependent and conditionally independent six-variable models. The maximum
# likelihood calculations are then used for model selection and as
# complimentary evidence for interpretations made using the Kullback-Leibler
# metrics (see README or Supplemental Information for more details).

# Load libraries
library(yada)
library(doParallel)
#library(nestfs)

# Clear the workspace
rm(list=ls())

# Re-direct print statements to a text file for a permanent record of
# processing
sink("results/make_multivariate_crossval_results_output.txt")

# Check that a results folder exists in the working directory
if(! ("results" %in% dir()) ) {
  stop("There is no 'results' folder in the working directory")
}

# Use all available cores for parallel processing
registerDoParallel(detectCores())

# The data directory is /results
data_dir <- "results"
# The "ID" that uniquely identifies this analysis:
analysis_name <- 'US'


# Perform multivariate model cross-validation using fold data
eval_list <- evaluate_multivariate_models(data_dir,
                                         analysis_name,
                                         eval_type="cv")

# Return maximum likelihood estimations
print(paste0("Out-of-sample negative log-likelihood for conditionally ",
             "independent model: ",eval_list$eval_cindep))
print(paste0("Out-of-sample negative log-likelihood for conditionally ",
             "dependent model: ",eval_list$eval_cdep))

# Stop clusters from parallel processing
stopImplicitCluster()

# End the re-directing of print statements to file
sink()