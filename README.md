## Final Project

## Overview/Motivation 

The goal for this project is to create a model that predicts an NBA player's yearly salary based on their age, team, role, season, and the dozens of other season statistics in this set. I'm predicting an NBA player's "deserved" salary based on factors/statistics, which is a regression problem. The variable I'm trying to predict is player_salary_in, which I will rename to player_salary.

I'm interested in the NBA, and thought this would be fun. Fans constantly bicker about different players' values, especially ones that are considered overpaid and ones that are underpaid. Finding a diamond in the rough (or vice versa) greatly impacts roster construction, which of course impacts game results. A prediction model would take much  more into account beyond comparing a salary amount to other players in the league at a given time, and would give someone a much better idea of whether a player met their contract demands in a given year.

## Data source

Here is my data source: a link to a Kaggle dataset of National Basketball Association individual player statistics and salary data from 1950 to 2017. I am using the "Basic Season - Season Stats" sheet.^[Here is a --- [link](https://www.kaggle.com/datasets/whitefero/nba-players-advanced-season-stats-19782016) to the Kaggle page with the dataset.].


## Folders

- `data\`: can find raw and cleaned versions of datasets
- `results\`: can find split and fitted/tuned models to folds, as well as final fit.
- `memos\`: can find project memos 1 and 2 here
- `recipes\`: can find feature-engineered and kitchen sink recipes, modified for each of the 6 model
types
- `data_splits\`: can find training and testing data/splits labeled accordingly, as well as the 15 folds
- `R scripts\`: can find R scripts here, which are detailed below:
- `codeboooks\`: can find each of codebooks to define variables for each of the datasets
- `plots\`: can find saved plots of final models here, labeled accordingly for the winning model and null one (baseline used for comparison)


## R Scripts

- `1_initial_setup`: transform and clean NBA data, split data into training/testing sets
- `2_recipe_1_kitchen_sink_nontree`: setting up, processing and saving kitchen sink recipe used for elastic net, null, and linear models
- `2_recipe_1_kitchen_sink_tree`: setting up, processing and saving kitchen sink recipe used for knn, random forest, and boosted tree models
- `2_recipe_2_nontree`: setting up, processing, and saving feature-engineered recipe for elastic net, null, and linear models
- `2_recipe_2_tree`: setting up, processing and saving feature-engineered recipe used for random forest, knn, boosted tree models
- `3_tune_bt_kitchen`: tuning and saving of the boosted tree model type with kitchen sink recipe
- `3_tune_rf_kitchen`: tuning and saving of the random forest model type with kitchen sink recipe
- `3_tune_elastic_net_kitchen`: tuning and saving of elastic net model type with kitchen sink recipe
- `3_tune_knn_kitchen`: tuning and saving of K-nearest neighbor model type with kitchen sink recipe
- `3_tune_bt_fe`: tuning and saving of the boosted tree model type with feature-engineered recipe
- `3_tune_rf_fe`: tuning and saving of the random forest model type with feature-engineered recipe
- `3_tune_elastic_net_fe`: tuning and saving of elastic net model type with feature-engineered recipe
- `3_tune_knn_fe`: tuning and saving of K-nearest neighbor model type with feature-engineered recipe
- `4_fold_fitting_fe`: fitting linear and null models to resamples with feature-engineered recipe, and saving
- `4_fold_fitting_kitchen`: fitting linear and null models to resamples with kitchen recipe, and saving
- `5_model_analysis_final_fit`: identifying best model for each model type, and making a table of the 12 to select winning model, which will be fitted to the entire training set. Making predictions of outcome variable, using/displaying RMSE metrics to analyze the models, and designing metric assessment tables.
- `6_final_fits_best`: Final fit for winning model on training data, testing prediction, and observed vs. predicted values plot
- `6_final_fits_null`: Final fit for null model on training data, testing prediction, and observed vs. predicted values plot. Used as standard of comparison.



## Reports

- `L06_model_tuning`: instructions for lab
- `Dowling_Ignacio_L06.qmd`: final report of lab
- `Dowling_Ignacio_LO5.html`: rendered file with final solutions