### Author: William Collier ###
# Necessary Libraries
library(dplyr) 

# Import data set (Choose one)
raw_workouts <- read.csv("~/Computer Science/Data Science/Project/Exercise Data Group Project/Top 50 Excerice for your body.csv")
raw_workouts <- read.csv("Top 50 Excerice for your body.csv")

###### Exploratory Data Analysis ###############################################

### Author: Taylor Turner ###
# Simple summary operation
summary(raw_workouts)

# Go through each attribute and perform EDA

## Name.of.Exercise

# Basic summary statistic
summary(raw_workouts$Name.of.Exercise)

# Verify there are no duplicates in names
raw_workouts %>%
  add_count(Name.of.Exercise) %>%
  filter(n>1) %>%
  distinct()

## Sets

  # Basic summary statistic
  summary(raw_workouts$Sets)

## Reps

  # Basic summary statistic
  summary(raw_workouts$Reps)

## Benefit

  # Basic summary statistic
  summary(raw_workouts$Benefit)

## Burns.Calories..per.30.min

  # Basic summary statistic
  summary(raw_workouts$Burns.Calories..per.30.min.)

## Target.Muscle.Group

  # Basic summary statistic
  summary(raw_workouts$Target.Muscle.Group)

## Equipment.Needed

  # Basic summary statistic
  summary(raw_workouts$Equipment.Needed)

## Difficulty.Level
  
  # Basic summary statistic
  summary(raw_workouts$Difficulty.Level)

###### Data Cleaning and Transformation ########################################

### Author: Taylor Turner ###
# Duplicate the data before transforming it
workouts <- raw_workouts

### Author: William Collier ###
# Mutate Data set for total amount of reps from entire workout
workouts <- workouts %>%
  mutate(
    total_reps = Sets * Reps
  )

### Author: William Collier ###
# Mutate Data set for Boolean value for Equipment Needed

workouts <- workouts %>%
  mutate(
    Equipment.Needed.Bool = 1
  )

### Author: William Collier ###
# Handles None or equipment as None since none is needed at the minimum
for (i in 1:nrow(workouts)){
  if (grepl("None", workouts$Equipment.Needed[i])){
    workouts$Equipment.Needed.Bool[i] <- 0
  }
}

### Author: William Collier ###
# Mutate Data Set for Muscle Group Boolean Columns
workouts <- workouts %>%
  mutate(
    Arms = 0,
    # Triceps, Shoulders, Biceps, Deltoids
    Chest = 0,
    # Chest
    Back = 0,
    # Back
    Legs = 0,
    # Quadriceps, Hamstrings, Glutes, Calves, Legs, Hip,
    Core = 0
    # Core, Obliques, Abs
  )

# Arms, chest, back, legs, core

for (i in 1:nrow(workouts)){
  
  if (grepl("Triceps", workouts$Target.Muscle.Group[i]) |
      grepl("Shoulders", workouts$Target.Muscle.Group[i]) |
      grepl("Biceps", workouts$Target.Muscle.Group[i]) |
      grepl("Deltoids", workouts$Target.Muscle.Group[i])) {
    workouts$Arms[i] <- 1
  }
  
  if (grepl("Chest", workouts$Target.Muscle.Group[i])){
    workouts$Chest[i] <- 1
  }
  
  if (grepl("Back", workouts$Target.Muscle.Group[i])){
    workouts$Back[i] <- 1
  }
  
  if (grepl("Quadriceps", workouts$Target.Muscle.Group[i]) | 
      grepl("Hamstrings", workouts$Target.Muscle.Group[i]) | 
      grepl("Glutes", workouts$Target.Muscle.Group[i]) | 
      grepl("Calves", workouts$Target.Muscle.Group[i]) | 
      grepl("Legs", workouts$Target.Muscle.Group[i]) | 
      grepl("Hip", workouts$Target.Muscle.Group[i])) {
    workouts$Legs[i] <- 1
  }
  
  if (grepl("Core", workouts$Target.Muscle.Group[i]) | 
      grepl("Obliques", workouts$Target.Muscle.Group[i]) | 
      grepl("Abs", workouts$Target.Muscle.Group[i])) {
    workouts$Core[i] <- 1
  }
  
  if (grepl("Full Body", workouts$Target.Muscle.Group[i])){
    workouts$Arms[i] <- 1
    workouts$Chest[i] <- 1
    workouts$Back[i] <- 1
    workouts$Legs[i] <- 1
    workouts$Core[i] <- 1
  }
}


### Author: William Collier ###
# Summary statistics for The whole data set and Calories Burned per 30 minutes
summary(workouts)

summary(workouts$Burns.Calories..per.30.min.)

