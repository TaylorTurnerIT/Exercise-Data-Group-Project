###### Setup ###################################################################

### Author: Taylor Turner ###
# Check if packages are installed for easy of installation
packages <- c("tidyverse", "ggplot2", "dplyr", "car", "caret", "randomForest", "rpart", "rpart.plot")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
# load libraries
library(tidyverse)
library(ggplot2)
library(dplyr)
library(car)
library(caret)
library(randomForest)
library(rpart)
library(rpart.plot)

### Author: Jonah Perkins ###
# Set the seed 
set.seed(36698156)
#best: 36698156, 36698143

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

### Author: William Collier ###
# Summary statistics for the mutated data set and Calories Burned per 30 minutes
summary(workouts)

summary(workouts$Burns.Calories..per.30.min.)

### Author: Jonah Perkins ###
#Create training and test data sets
trainIndex <- createDataPartition(workouts$"Burns.Calories..per.30.min.", 
                                  p = .7, 
                                  list = FALSE, 
                                  times = 1)

trainData <- workouts[trainIndex, ]
testData <- workouts[-trainIndex, ]

summary(trainData)
summary(testData)

#-------------------------------------------------------------------------------------------------------------------------

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
regression_predictions <- predict(model, newdata = testData)

# Calculate performance
regression_rmse <- sqrt(mean((testData$Burns.Calories..per.30.min. - regression_predictions)^2))
regression_r2 <- cor(testData$Burns.Calories..per.30.min., regression_predictions)^2

mean_target <- mean(testData$Burns.Calories..per.30.min.)
percentage_error <- (regression_rmse / mean_target) * 100
cat("RMSE as % of mean:", percentage_error, "%\n")

#  performance metrics
cat("RMSE:", regression_rmse, "\n")
cat("R-squared:", regression_r2, "\n")

#-------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------

### Author: Gavin Walker ###
# Section for Decision Tree

dt_model_tuned <- rpart(
  Burns.Calories..per.30.min. ~ Equipment.Needed.Bool + Difficulty.Level + total_reps + Arms + Chest + Back + Legs + Core,
  data = trainData,
  control = rpart.control(cp = 0.001, maxdepth = 10, minsplit = 5)
)

predictions_dt_tuned <- predict(dt_model_tuned, newdata = testData)

# Calculates the root mean square error and prints it out
rmse_dt_tuned <- sqrt(mean((predictions_dt_tuned - testData$Burns.Calories..per.30.min.)^2))
cat("RMSE: ", rmse_dt_tuned, "\n")

# Calculates the RMSE as a percentage of the mean target value
mean_target <- mean(testData$Burns.Calories..per.30.min.)
percentage_error_tuned <- (rmse_dt_tuned / mean_target) * 100
cat("RMSE as % of mean:", percentage_error_tuned, "%\n")

# Plots a visualization of the decision tree
rpart.plot(dt_model_tuned)

# Calculates R Squared for the model
r_squared_dt <- cor(testData$Burns.Calories..per.30.min., predictions_dt_tuned)^2
cat("R Squared:", r_squared_dt, "%\n")

#------------------------------------

# Gets feature importance
feature_importance <- dt_model_tuned$variable.importance

# Prints feature importance
print(feature_importance)

# Normalizes the features importance as percentages
feature_importance <- feature_importance / sum(feature_importance) * 100

importance_df <- data.frame(
  Feature = names(feature_importance),
  Importance = feature_importance
)

# Plots feature importance for the decision tree model
ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance, fill = Feature)) +
  geom_bar(stat = "identity", width = 0.7) +
  labs(
    title = "Feature Importance in Decision Tree",
    x = "Feature",
    y = "Importance (%)"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

print(importance_df)

#------------------------------------

## Creates a baseline model from the mean to compare the decision tree model to
mean_baseline <- mean(trainData$Burns.Calories..per.30.min.)

predictions_mean <- rep(mean_baseline, nrow(testData))

# Calculate RMSE and R-squared
rmse_mean <- sqrt(mean((testData$Burns.Calories..per.30.min. - predictions_mean)^2))

cat("Baseline Mean RMSE:", rmse_mean, "\n")
cat("Decision Tree RMSE: ", rmse_dt_tuned, "\n")

#------------------------------------

# Evaluates the model with the training data to test for overfitting
train_predictions <- predict(dt_model_tuned, newdata = trainData)
train_rmse <- sqrt(mean((train_predictions - trainData$Burns.Calories..per.30.min.)^2))

# Evaluation metrics for training and test data
cat("Train RMSE:", train_rmse, "\n")
cat("Test RMSE:", rmse_dt_tuned, "\n")

mean_target_trained <- mean(trainData$Burns.Calories..per.30.min.)
percentage_error_trained_tuned <- (train_rmse / mean_target_trained) * 100
cat("Train RMSE as % of mean:", percentage_error_trained_tuned, "%\n")
cat("Test RMSE as % of mean:", percentage_error_tuned, "%\n")

#------------------------------------

## Graph to compare RMSE of Baseline Mean, Lin Reg, and Decision Tree
dt_rmse_metrics <- data.frame(
  Model = c("Baseline Mean", "Multiple Linear Regression", "Decision Tree"),
  RMSE = c(rmse_mean, regression_rmse, rmse_dt_tuned)
)

dt1_rmse_plot <- ggplot(dt_rmse_metrics, aes(x = Model, y = RMSE, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", RMSE)), vjust = -0.5) +
  labs(
    title = "RMSE Comparison Across Models",
    x = "Model",
    y = "RMSE (Calories)"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  ) +
  scale_fill_brewer(palette = "Set2")

print(dt1_rmse_plot)

#------------------------------------

## Graph to compare the R-squared values of the Multiple Linear Regression and Decision Tree models
r2_metrics <- data.frame(
  R_Squared_Model = c("Multiple Linear Regression","Decision Tree"),
  R_squared = c(regression_r2, r_squared_dt)
)

dt1_r2_plot <- ggplot(r2_metrics, aes(x = R_Squared_Model, y = R_squared, fill = R_Squared_Model)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", R_squared)), vjust = -0.5) +
  labs(
    title = "R-Squared Comparison Across Models",
    x = "Model",
    y = "R-Squared"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  ) +
  scale_fill_brewer(palette = "Set2")

print(dt1_r2_plot)

#------------------------------------

## Graph to compare the RMSE for the training and test data to check for over-fitting
overfitting_metrics <- data.frame(
  Model = c("Train Data","Test Data"),
  RMSE = c(train_rmse, rmse_dt_tuned)
)

overfitting_plot <- ggplot(overfitting_metrics, aes(x = Model, y = RMSE, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", RMSE)), vjust = -0.5) +
  labs(
    title = "RMSE Comparison for Training and Test Data Decision Trees",
    x = "Model",
    y = "RMSE"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  ) +
  scale_fill_brewer(palette = "Set2")

print(overfitting_plot)


#-------------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------

### Author: Jonah Perkins ###
# Creating a predictive model using Random Forest

# Define the training control
trainControl <- trainControl(method = "cv", number = 5, classProbs = TRUE, summaryFunction = defaultSummary)

# Train the Random Forest model
rfModel <- train(Burns.Calories..per.30.min. ~ Equipment.Needed.Bool+Difficulty.Level+total_reps+Arms+Chest+Back+Legs+Core,
                 data = trainData, 
                 method = "rf", 
                 trControl = trainControl,
                 tuneLength = 10,
                 tuneGrid = expand.grid(mtry = c(7,8,9,10,11,12,13)),
                 ntree = 900,
                 nodesize = 13,
                 maxnodes = 30,
                 importance = TRUE)

# Print the model
print(rfModel)

# Predict on the test data
rf_predictions <- predict(rfModel, newdata = testData)

# Calculate RMSE
rf_rmse <- sqrt(mean((rf_predictions - testData$Burns.Calories..per.30.min.)^2))
rf_r2 <- cor(testData$Burns.Calories..per.30.min., rf_predictions)^2

cat("RMSE:", rf_rmse, "\n")

# Evaluate RMSE. Ideally, the percentage <10%-20%
mean_target <- mean(testData$Burns.Calories..per.30.min.)
percentage_error <- (rf_rmse / mean_target) * 100
cat("RMSE as % of mean:", percentage_error, "%\n")

r_squared_rf <- cor(testData$Burns.Calories..per.30.min., rf_predictions)^2
cat("R Squared:", r_squared_rf, "%\n")

cat("Baseline Mean RMSE:", rmse_mean, "\n")
cat("Decision Tree RMSE: ", rmse_dt_tuned, "\n")
cat("Random Forest RMSE: ", rf_rmse, "\n")


# Evaluates the model with the training data to test for overfitting
train_predictions <- predict(rfModel, newdata = trainData)
train_rmse <- sqrt(mean((train_predictions - trainData$Burns.Calories..per.30.min.)^2))

# Evaluation metrics for training and test data
cat("Train RMSE:", train_rmse, "\n")
cat("Test RMSE:", rf_rmse, "\n")

mean_target_trained <- mean(trainData$Burns.Calories..per.30.min.)
percentage_error_trained_tuned <- (train_rmse / mean_target_trained) * 100
cat("Train RMSE as % of mean:", percentage_error_trained_tuned, "%\n")
cat("Test RMSE as % of mean:", percentage_error, "%\n")

#-------------------------------------------------------------------------------------------------------------------------
### Author: Taylor Turner ###

# Create a df that shows actual values and predicted values for each model for comparison
test_predictions <- data.frame(
  Index = 1:nrow(testData),
  Actual = testData$Burns.Calories..per.30.min.,
  Linear_Regression = regression_predictions,
  Decision_Tree = predictions_dt_tuned,
  Random_Forest = rf_predictions
)

# Multiple bar plot for all test data element comparisons
comparison_plot <- test_predictions %>%
  pivot_longer(
    cols = c(Actual, Linear_Regression, Decision_Tree, Random_Forest),
    names_to = "Model",
    values_to = "Predicted"
  ) %>%
  ggplot(aes(x = as.factor(Index))) +
  geom_bar(aes(y = Predicted, fill = Model), stat = "identity", alpha = 0.5, position = "dodge") +
  labs(
    title = "Actual vs Predicted Calories Burned for Each Test Exercises",
    x = "Test Exercises",
    y = "Calories Burned (per 30 min)",
    fill = "Model"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "bottom"
  )

# compare means
mean_predictions <- data.frame(
  Model = c("Actual", "Linear Regression", "Decision Tree", "Random Forest"),
  Value = c(
    mean(test_predictions$Actual),
    mean(test_predictions$Linear_Regression),
    mean(test_predictions$Decision_Tree),
    mean(test_predictions$Random_Forest)
  )
)

means_plot <- ggplot(mean_predictions, aes(x = Model, y = Value, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = round(Value, 1)), vjust = -0.5) +
  labs(
    title = "Average Predicted vs Actual Calories Burned (per 30 min)",
    x = "Model",
    y = "Calories"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  ) +
  scale_fill_brewer(palette = "Set2")

performance_metrics <- data.frame(
  Model = c("Linear Regression", "Decision Tree", "Random Forest"),
  RMSE = c(regression_rmse, rmse_dt_tuned, rf_rmse),
  R_squared = c(regression_r2, r_squared_dt, rf_r2)
)

performance <- performance_metrics %>%
  pivot_longer(
    cols = c(RMSE, R_squared),
    names_to = "Metric",
    values_to = "Value"
  )

# Create individual plots for RMSE and R-squared
rmse_plot <- ggplot(performance_metrics, aes(x = Model, y = RMSE, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", RMSE)), vjust = -0.5) +
  labs(
    title = "RMSE Comparison Across Models",
    x = "Model",
    y = "RMSE (Calories)"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  ) +
  scale_fill_brewer(palette = "Set2")

r2_plot <- ggplot(performance_metrics, aes(x = Model, y = R_squared, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", R_squared)), vjust = -0.5) +
  labs(
    title = "R^2 Comparison Across Models",
    x = "Model",
    y = "R²"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none"
  ) +
  scale_fill_brewer(palette = "Set2")

# Display all plots
print(comparison_plot)
print(means_plot)
print(rmse_plot)
print(r2_plot)
