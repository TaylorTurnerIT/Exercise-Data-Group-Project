###### Setup ###################################################################

### Author: Taylor Turner ###
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")

library(tidyverse)
library(ggplot2)
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
  
  # Visualize with box plot
  barplot(table(raw_workouts$Sets), xlab = "Occurrences", ylab = "Set Count", main = "Number of Sets for Exercises")
  
## Reps

  # Basic summary statistic
  summary(raw_workouts$Reps)
  
  # Visualize with box plot
  barplot(table(raw_workouts$Reps), xlab = "Occurrences", ylab = "Rep Count", main = "Number of Reps for Exercises")
  

## Benefit

  # Basic summary statistic
  summary(raw_workouts$Benefit)

## Burns.Calories..per.30.min

  # Basic summary statistic
  summary(raw_workouts$Burns.Calories..per.30.min.)
  
  # Visualize with box plot
  boxplot(raw_workouts$Burns.Calories..per.30.min., ylab = "Calorie Burn Rate", main = "Calorie Burn Rate for Exercises")

## Target.Muscle.Group

  # Basic summary statistic
  summary(raw_workouts$Target.Muscle.Group)
  
  # Further visualization appears later after transformation

## Equipment.Needed

  # Basic summary statistic
  summary(raw_workouts$Equipment.Needed)
  
  # Further visualization appears later after transformation
  
## Difficulty.Level
  
  # Basic summary statistic
  summary(raw_workouts$Difficulty.Level)
  
  barplot(table(raw_workouts$Difficulty.Level, ))

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
    Equipment.Needed.Bool = TRUE
  )

### Author: William Collier ###
# Handles None or equipment as None since none is needed at the minimum
for (i in 1:nrow(workouts)){
  if (grepl("None", workouts$Equipment.Needed[i])){
    workouts$Equipment.Needed.Bool[i] <- FALSE
  }
}

### Author: Taylor Turner ###
# Visualize the equipment needed as a barplot

barplot(c(sum(workouts$Equipment.Needed.Bool), 50-sum(workouts$Equipment.Needed.Bool)), ylab = "Count", main = "Equipment Requirement for Exercises", names.arg = c("Required", "Not Required"))

### Author: William Collier ###
# Mutate Data Set for Muscle Group Boolean Columns
workouts <- workouts %>%
  mutate(
    Arms = FALSE,
    # Triceps, Shoulders, Biceps, Deltoids
    Chest = FALSE,
    # Chest
    Back = FALSE,
    # Back
    Legs = FALSE,
    # Quadriceps, Hamstrings, Glutes, Calves, Legs, Hip,
    Core = FALSE
    # Core, Obliques, Abs
  )

# Arms, chest, back, legs, core

for (i in 1:nrow(workouts)){
  
  if (grepl("Triceps", workouts$Target.Muscle.Group[i]) |
      grepl("Shoulders", workouts$Target.Muscle.Group[i]) |
      grepl("Biceps", workouts$Target.Muscle.Group[i]) |
      grepl("Deltoids", workouts$Target.Muscle.Group[i])) {
    workouts$Arms[i] <- TRUE
  }
  
  if (grepl("Chest", workouts$Target.Muscle.Group[i])){
    workouts$Chest[i] <- TRUE
  }
  
  if (grepl("Back", workouts$Target.Muscle.Group[i])){
    workouts$Back[i] <- TRUE 
  }
  
  if (grepl("Quadriceps", workouts$Target.Muscle.Group[i]) | 
      grepl("Hamstrings", workouts$Target.Muscle.Group[i]) | 
      grepl("Glutes", workouts$Target.Muscle.Group[i]) | 
      grepl("Calves", workouts$Target.Muscle.Group[i]) | 
      grepl("Legs", workouts$Target.Muscle.Group[i]) | 
      grepl("Hip", workouts$Target.Muscle.Group[i])) {
    workouts$Legs[i] <- TRUE
  }
  
  if (grepl("Core", workouts$Target.Muscle.Group[i]) | 
      grepl("Obliques", workouts$Target.Muscle.Group[i]) | 
      grepl("Abs", workouts$Target.Muscle.Group[i])) {
    workouts$Core[i] <- TRUE
  }
  
  if (grepl("Full Body", workouts$Target.Muscle.Group[i])){
    workouts$Arms[i] <- TRUE
    workouts$Chest[i] <- TRUE
    workouts$Back[i] <- TRUE
    workouts$Legs[i] <- TRUE
    workouts$Core[i] <- TRUE
  }
}


### Author: William Collier ###
# Summary statistics for the mutated data set and Calories Burned per 30 minutes
summary(workouts)

summary(workouts$Burns.Calories..per.30.min.)

### Author: ###
# Section for Multiple Linear Regression

### Author: ###
# Section for Decision Tree

### Author: ###
# Section for Random Forest

