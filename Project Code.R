###### Setup ###################################################################

### Author: Taylor Turner ###
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("car")
install.packages("caret")
install.packages("randomForest")

### Author: William Collier ###
# Necessary Libraries
library(dplyr) 
library(tidyverse)
library(ggplot2)
library(caret)
library(randomForest)
library(car)

### Author: Jonah Perkins ###
# Set the seed 
set.seed(82698143)

# Import the data set,   choosing the file titled "Top 50 Excerice for your body" wherever you have it downloaded 
raw_workouts <- read.csv(file.choose())

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

raw_workouts$Difficulty.Level <- as.factor(raw_workouts$Difficulty.Level)

# Basic summary statistic
summary(raw_workouts$Difficulty.Level)

# Gavin Walker
# Plot for difficult level occurences
barplot(table(raw_workouts$Difficulty.Level), xlab = "Difficulty level", ylab = "Occurences", main = "Variety of Difficulty Levels for Exercises")

###### Data Cleaning and Transformation ########################################

### Author: Taylor Turner ###
# Duplicate the data before transforming it
workouts <- raw_workouts

### Author: Gavin Walker ###
# Mutate Data set for total amount of reps from entire workout
workouts <- workouts %>%
  mutate(
    total_reps = Sets * Reps
  )

### Author: William Collier ###
# Mutate Data set for Boolean value for Equipment Needed

workouts <- workouts %>%
  mutate(
    Equipment.Needed.Bool = "TRUE"
  )

### Author: William Collier ###
# Handles None or equipment as None since none is needed at the minimum
for (i in 1:nrow(workouts)){
  if (grepl("None", workouts$Equipment.Needed[i])){
    workouts$Equipment.Needed.Bool[i] <- "FALSE"
  }
}
workouts$Equipment.Needed.Bool <- as.factor(workouts$Equipment.Needed.Bool)

### Author: Taylor Turner ###
# Visualize the equipment needed as a barplot

#barplot(c(workouts$Equipment.Needed.Bool, workouts$Equipment.Needed.Bool), ylab = "Count", main = "Equipment Requirement for Exercises", names.arg = c("Required", "Not Required"))

### Author: William Collier ###
# Mutate Data Set for Muscle Group Boolean Columns
workouts <- workouts %>%
  mutate(
    Arms = "FALSE",
    # Triceps, Shoulders, Biceps, Deltoids
    Chest = "FALSE",
    # Chest
    Back = "FALSE",
    # Back
    Legs = "FALSE",
    # Quadriceps, Hamstrings, Glutes, Calves, Legs, Hip,
    Core = "FALSE"
    # Core, Obliques, Abs
  )

# Arms, chest, back, legs, core

for (i in 1:nrow(workouts)){
  
  if (grepl("Triceps", workouts$Target.Muscle.Group[i]) |
      grepl("Shoulders", workouts$Target.Muscle.Group[i]) |
      grepl("Biceps", workouts$Target.Muscle.Group[i]) |
      grepl("Deltoids", workouts$Target.Muscle.Group[i])) {
    workouts$Arms[i] <- "TRUE"
  }
  
  if (grepl("Chest", workouts$Target.Muscle.Group[i])){
    workouts$Chest[i] <- "TRUE"
  }
  
  if (grepl("Back", workouts$Target.Muscle.Group[i])){
    workouts$Back[i] <- "TRUE"
  }
  
  if (grepl("Quadriceps", workouts$Target.Muscle.Group[i]) | 
      grepl("Hamstrings", workouts$Target.Muscle.Group[i]) | 
      grepl("Glutes", workouts$Target.Muscle.Group[i]) | 
      grepl("Calves", workouts$Target.Muscle.Group[i]) | 
      grepl("Legs", workouts$Target.Muscle.Group[i]) | 
      grepl("Hip", workouts$Target.Muscle.Group[i])) {
    workouts$Legs[i] <- "TRUE"
  }
  
  if (grepl("Core", workouts$Target.Muscle.Group[i]) | 
      grepl("Obliques", workouts$Target.Muscle.Group[i]) | 
      grepl("Abs", workouts$Target.Muscle.Group[i])) {
    workouts$Core[i] <- "TRUE"
  }
  
  if (grepl("Full Body", workouts$Target.Muscle.Group[i])){
    workouts$Arms[i] <- "TRUE"
    workouts$Chest[i] <- "TRUE"
    workouts$Back[i] <- "TRUE"
    workouts$Legs[i] <- "TRUE"
    workouts$Core[i] <- "TRUE"
  }
}

workouts$Arms <- as.factor(workouts$Arms)
workouts$Chest <- as.factor(workouts$Chest)
workouts$Back <- as.factor(workouts$Back)
workouts$Legs <- as.factor(workouts$Legs)
workouts$Core <- as.factor(workouts$Core)

## Author: Jonah Perkins ###
# Create a column to show the Burns.Calories.Range

workouts <- workouts %>%
  mutate(
    Burns.Calories.Range = ""
    # Allows for classification
  )

for (i in 1:nrow(workouts)){
  if (workouts$Burns.Calories..per.30.min.[i] < 150){
    workouts$Burns.Calories.Range[i] = "<150"
  }
  #...
}

### Author: William Collier ###
# Summary statistics for the mutated data set and Calories Burned per 30 minutes
summary(workouts)

summary(workouts$Burns.Calories..per.30.min.)

### Author: Jonah Perkins ###
#Create training and test data sets
trainIndex <- createDataPartition(workouts$"Burns.Calories..per.30.min.", 
                                  p = .8, 
                                  list = FALSE, 
                                  times = 1)

trainData <- workouts[trainIndex, ]
testData <- workouts[-trainIndex, ]

summary(trainData)
summary(testData)

### Author: Taylor Turner ###
# Multiple regression
# Fit model on training data

model <- lm(Burns.Calories..per.30.min. ~ total_reps + Equipment.Needed.Bool + 
              Difficulty.Level + Arms + Chest + Back + Legs + Core, 
            data = trainData)

par(mfrow=c(2,2))
plot(model) 
avPlots(model)
summary(model)

# Make predictions on test set
predictions <- predict(model, newdata = testData)

# Calculate performance
rmse <- sqrt(mean((testData$Burns.Calories..per.30.min. - predictions)^2))
r2 <- cor(testData$Burns.Calories..per.30.min., predictions)^2

mean_target <- mean(testData$Burns.Calories..per.30.min.)
percentage_error <- (rmse / mean_target) * 100
cat("RMSE as % of mean:", percentage_error, "%\n")

#  performance metrics
cat("RMSE:", rmse, "\n")
cat("R-squared:", r2, "\n")

### Author: Gavin Walker ###
# Section for Decision Tree

# Defines the training control
train_controlDT <- trainControl(method = "cv", number = 10)

# Train the decision tree model
dt_model <- train(
  Burns.Calories..per.30.min. ~ Equipment.Needed.Bool+Difficulty.Level+total_reps+Arms+Chest+Back+Legs+Core,                   
  data = trainData,               
  method = "rpart",               
  trControl = train_controlDT,      
  tuneLength = 10                 
)

# Prints the model
print(dt_model)

# Views the best parameter for tuning
print(dt_model$bestTune)

# Predicts based on test data
predictions <- predict(dt_model, newdata = testData)

# Calculates the root mean square error and prints it out
rmse_dt <- sqrt(mean((predictions - testData$Burns.Calories..per.30.min.)^2))
cat("RMSE: ", rmse_dt, "\n")


### Author: Jonah Perkins ###
# Creating a predictive model using Random Forest

# Define the training control
trainControl <- trainControl(method = "cv", number = 5)

# Train the Random Forest model
rfModel <- train(Burns.Calories..per.30.min. ~ Equipment.Needed.Bool+Difficulty.Level+total_reps+Arms+Chest+Back+Legs+Core,
                 data = trainData, 
                 method = "rf", 
                 trControl = trainControl,
                 tuneLength = 5)

# Print the model
print(rfModel)

# Predict on the test data
predictions <- predict(rfModel, newdata = testData)

# Calculate RMSE
rmse <- sqrt(mean((predictions - testData$Burns.Calories..per.30.min.)^2))
cat("RMSE:", rmse, "\n")
# Depending on what the seed changes this to, the model might need to be tweaked

# Evaluate RMSE. Ideally, the percentage <10%-20%
mean_target <- mean(testData$Burns.Calories..per.30.min.)
percentage_error <- (rmse / mean_target) * 100
cat("RMSE as % of mean:", percentage_error, "%\n")

#Plot Predicted vs. Actual
ggplot(data = NULL, aes(x = testData$Burns.Calories..per.30.min., y = predictions)) +
  geom_point(color = "blue") +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Predicted vs. Actual", x = "Actual Calories Burned", y = "Predicted Calories Burned") +
  theme_minimal()