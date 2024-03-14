# 1: Writing Codebooks for Datasets

# load packages
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(janitor)
library(skimr)
library(ggplot2)
library(dplyr)

# handle common conflicts
tidymodels_prefer()

# writing codebooks
nba_season_stats_codebook <- tibble(
  variables = c("#", "Season Start", "Player Name", "Player Salary in $", "Pos", "Age", 
                "Tm", "G", "GS", "MP", "PER", "TS%", "3PAr", "FTr", "ORB%", 
                "DRB%", "TRB%", "AST%", "STL%", "BLK%", 
                "TOV%", "USG%", "blanl", "OWS", "DWS", 
                "WS", "WS/48", "blank2", "OBPM", "DBPM",
                "BPM", "VORP", "FG", "FGA", "FG%", "3P", "3PA", "3P%",
                "2P", "2PA", "2P%", "eFG%", "FT", "FTA", "FT%", "ORB", 
                "DRB", "TRB", "AST", "STL", "BLK", "TOV", "PF", "PTS"),
  
  descriptions = c("ID Number", "Year", "player name", "Player salary that year in $", "Position", 
                   "Age", "Team", "Games Played", "Games started", "Minutes played",
                   "Player Efficiency Rating", 
                   "True shooting percentage", "Three-point attempt rate", 
                   "Free throw attempt rate", "Offensive rebounding percentage", 
                   "Defensive rebounding percentage", 
                   "Total rebounding percentage", "Assist percentage", "Steal percentage", 
                   "Block percentage", "Turnover percentage", "Usage percentage", 
                   "Blank variable", "Offensive win shares", "Defensive win shares",
                   "Win shares", "Win shares per 48 minutes", "Blank variable", 
                   "Offensive box plus-minus", "Defensive box plus-minus", 
                   "Total box plus-minus", "Value over replacement player", 
                   "Field goal shots made", "Field goals attempted", 
                   "Field goal percentage", "Three-pointers made", "Three-pointers attempted",
                   "Three-point percentage",
                   "Two-pointers made", "Two-pointers attempted", "Two-point percentage",
                   "Effective field goal percentage (weighting three-pointers as 1.5 times 
                   a two-pointer)", "Free throws made", "Free throws attempted",
                   "Free throw percentage", "Offensive rebounds", "Defensive rebounds",
                   "Total rebounds", "Assists", "Steals", "Blocks", "Turnovers", 
                   "Personal fouls", "Points"))

nba_season_statistics_codebook <- tibble(
  variables = c("number", "season_start", "player_name", "player_salary", "pos", "age", 
                "tm", "g", "gs", "mp", "per", "ts_percent", "x3p_ar", "f_tr", "orb_percent", 
                "drb_percent", "trb_percent", "ast_percent", "stl_percent", "blk_percent", 
                "tov_percent", "usg_percent", "blanl", "ows", "dws", 
                "ws", "ws_48", "blank2", "obpm", "dbpm",
                "bpm", "vorp", "fg", "fga", "fg_percent", "x3p", "x3pa", "x3p_percent",
                "x2p_percent", "x2pa", "x2p_percent", "e_fg_percent", "ft", "fta", "ft_percent", 
                "orb", "drb", "trb", "ast", "stl", "blk", "tov", "pf", "pts"),
  
  descriptions = c("ID Number", "Year", "player name", "Player salary that year in $", "Position", 
                   "Age", "Team", "Games Played", "Games started", "Minutes played",
                   "Player Efficiency Rating", 
                   "True shooting percentage", "Three-point attempt rate", 
                   "Free throw attempt rate", "Offensive rebounding percentage", 
                   "Defensive rebounding percentage", 
                   "Total rebounding percentage", "Assist percentage", "Steal percentage", 
                   "Block percentage", "Turnover percentage", "Usage percentage", 
                   "Blank variable", "Offensive win shares", "Defensive win shares",
                   "Win shares", "Win shares per 48 minutes", "Blank variable", 
                   "Offensive box plus-minus", "Defensive box plus-minus", 
                   "Total box plus-minus", "Value over replacement player", 
                   "Field goal shots made", "Field goals attempted", 
                   "Field goal percentage", "Three-pointers made", "Three-pointers attempted",
                   "Three-point percentage",
                   "Two-pointers made", "Two-pointers attempted", "Two-point percentage",
                   "Effective field goal percentage (weighting three-pointers as 1.5 times 
                   a two-pointer)", "Free throws made", "Free throws attempted",
                   "Free throw percentage", "Offensive rebounds", "Defensive rebounds",
                   "Total rebounds", "Assists", "Steals", "Blocks", "Turnovers", 
                   "Personal fouls", "Points"))

nba_season_statistics_cleaned_codebook <- tibble(
  variables = c("number", "season_start", "player_name", "player_salary", "pos", "age", 
                "tm", "g", "gs", "mp", "per", "ts_percent", "x3p_ar", "f_tr", "orb_percent", 
                "drb_percent", "trb_percent", "ast_percent", "stl_percent", "blk_percent", 
                "tov_percent", "usg_percent", "ows", "dws", 
                "ws", "ws_48", "obpm", "dbpm",
                "bpm", "vorp", "fg", "fga", "fg_percent", "x3p", "x3pa", "x3p_percent",
                "x2p_percent", "x2pa", "x2p_percent", "e_fg_percent", "ft", "fta", "ft_percent", 
                "orb", "drb", "trb", "ast", "stl", "blk", "tov", "pf", "pts", "log_10_player_salary"),
  
  descriptions = c("ID Number", "Year", "player name", "Player salary that year in $", "Position", 
                   "Age", "Team", "Games Played", "Games started", "Minutes played",
                   "Player Efficiency Rating", 
                   "True shooting percentage", "Three-point attempt rate", 
                   "Free throw attempt rate", "Offensive rebounding percentage", 
                   "Defensive rebounding percentage", 
                   "Total rebounding percentage", "Assist percentage", "Steal percentage", 
                   "Block percentage", "Turnover percentage", "Usage percentage", 
                    "Offensive win shares", "Defensive win shares",
                   "Win shares", "Win shares per 48 minutes",
                   "Offensive box plus-minus", "Defensive box plus-minus", 
                   "Total box plus-minus", "Value over replacement player", 
                   "Field goal shots made", "Field goals attempted", 
                   "Field goal percentage", "Three-pointers made", "Three-pointers attempted",
                   "Three-point percentage",
                   "Two-pointers made", "Two-pointers attempted", "Two-point percentage",
                   "Effective field goal percentage (weighting three-pointers as 1.5 times 
                   a two-pointer)", "Free throws made", "Free throws attempted",
                   "Free throw percentage", "Offensive rebounds", "Defensive rebounds",
                   "Total rebounds", "Assists", "Steals", "Blocks", "Turnovers", 
                   "Personal fouls", "Points", "Log-10-Transformed Player Salary ($)"))


# saving codebooks
write_csv(nba_season_stats_codebook, file = "codebooks/nba_season_stats_codebook.csv")
write_csv(nba_season_statistics_codebook, file = "codebooks/nba_season_statistics_codebook.csv")
write_csv(nba_season_statistics_cleaned_codebook, 
          file = "codebooks/nba_season_statistics_cleaned_codebook.csv")