# Necessary Libraries
library(dplyr) 

# Import data set 
workouts <- read.csv("~/Computer Science/Data Science/Project/Exercise Data Group Project/Top 50 Excerice for your body.csv")

########################### Mutate Data set for total amount of reps from entire workout ###########################
workouts <- workouts %>%
  mutate(
    total_reps = Sets * Reps
  )

########################### Mutate Data set for Boolean value for Equipment Needed ###########################

workouts <- workouts %>%
  mutate(
    Equipment.Needed.Bool = 1
  )

#handles None or equipment as None since none is needed at the minimum
for (i in 1:nrow(workouts)){
  if (grepl("None", workouts$Equipment.Needed[i])){
    workouts$Equipment.Needed.Bool[i] <- 0
  }
}

########################### Mutate Data Set for Muscle Group Boolean Columns ###########################
workouts <- workouts %>%
  mutate(
    Arms = 0,
    #Triceps, Shoulders, Biceps, Deltoids
    Chest = 0,
    #Chest
    Back = 0,
    #Back
    Legs = 0,
    #Quadriceps, Hamstrings, Glutes, Calves, Legs, Hip,
    Core = 0
    #Core, Obliques, Abs
  )

#arms, chest, back, legs, core

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


#summary statistics for The Whole Data set and Calaries Burned per 30 minutes
summary(workouts)

summary(workouts$Burns.Calories..per.30.min.)

