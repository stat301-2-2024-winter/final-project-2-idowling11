## Basic repo setup for final project

Describe project and general structure of repo ...

## Overview/Motivation 

The goal for this project is to create a model that predicts an NBA player's yearly salary based on their age, team, role, season, and the dozens of other season statistics in this set. I'm predicting an NBA player's "deserved" salary based on factors/statistics, which is a regression problem. The variable I'm trying to predict is player_salary_in, which I will rename to player_salary.

I'm interested in the NBA, and thought this would be fun. Fans constantly bicker about different players' values, especially ones that are considered overpaid and ones that are underpaid. Finding a diamond in the rough (or vice versa) greatly impacts roster construction, which of course impacts game results. A prediction model would take much  more into account beyond comparing a salary amount to other players in the league at a given time, and would give someone a much better idea of whether a player met their contract demands in a given year.

## Data source

Here is my data source: a link to a Kaggle dataset of National Basketball Association individual player statistics and salary data from 1950 to 2017. I am using the "Basic Season - Season Stats" sheet.^[Here is a --- [link](https://www.kaggle.com/datasets/whitefero/nba-players-advanced-season-stats-19782016) to the Kaggle page with the dataset.].


## Folders

- `data\`: can find raw and cleaned versions of datasets
- `results\`: can find split and fitted/tuned models to folds, as well as final fit.
- `memos\`: can find project memos 1 and 2 here
- `recipes\`: can find feature-engineered and kitchen sink recipes, modified for each of the 6 model types
- `data_splits\`: can find training and testing data/splits labeled accordingly, as well as the 15 folds
- `R scripts\`: can find R scripts here, which are detailed below:


## R Scripts

- `1_initial_setup`: transform and clean NBA data, split data into training/testing sets
- `2_recipe_1`: setting up, processing and saving kitchen sink recipe for each of the 6 model types
- `2_recipe_2`: setting up, processing, and saving feature-engineered recipe for each of the 6 model types
- `3_tune_bt`: tuning and saving of the boosted tree model type
- `3_tune_rf`: tuning and saving of the random forest model type
- `3_tune_ridge`: tuning and saving of ridge model type
- `3_tune_knn`: tuning and saving of K-nearest neighbor model type
- `4_fold_fitting`: fitting 6 model types to resamples, and saving
- `5_model_analysis_final_fit`: identifying best model for each model type, then using the remaining 6 to pick a winning model, which will be fitted to the entire training set. Making predictions of outcome variable, using/displaying RMSE metrics to analyze the models, and designing metric assessment tables.


## Reports

- `L06_model_tuning`: instructions for lab
- `Dowling_Ignacio_L06.qmd`: final report of lab
- `Dowling_Ignacio_LO5.html`: rendered file with final solutions