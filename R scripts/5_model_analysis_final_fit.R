# 5: Model analysis and final fit

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
library(doParallel)

# set seed
set.seed(8)

# handle common conflicts
tidymodels_prefer()