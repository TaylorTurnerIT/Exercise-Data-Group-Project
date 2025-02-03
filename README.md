# Predicting Exercise Effectiveness

![R Version](https://img.shields.io/badge/R-%3E%3D4.1.0-blue)
![GitHub](https://img.shields.io/badge/License-MIT-green)
![Last Commit](https://img.shields.io/badge/last%20commit-November%202024-brightgreen)

A machine learning project to predict calorie burn rates for exercises using regression models. Developed as part of a college data analytics course.

## 📖 Table of Contents
- [Problem Statement](#-problem-statement)
- [Dataset](#-dataset)
- [Technical Approach](#-technical-approach)
- [Results](#-results)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
- [Model Limitations](#-model-limitations)
- [Contributing](#-contributing)
- [Known Issues](#-known-issues)
- [Contributors](#-contributors)
- [License](#-license)
- [Changelog](#-changelog)
- [Acknowledgments](#-acknowledgments)

## 🎯 Problem Statement
The fitness industry lacks accessible tools for predicting exercise effectiveness. This project aims to:
- Build a predictive model for calorie burn rates using exercise attributes (reps, muscle groups, difficulty, etc.)
- Compare performance of **Multiple Linear Regression**, **Decision Trees**, and **Random Forests**
- Empower fitness enthusiasts to estimate exercise effectiveness without lab testing

## 📊 Dataset
**Source**: [Best 50 Exercises for Your Body](https://www.kaggle.com/datasets/prajwaldongre/best-50-exercise-for-your-body) (Prajwal Dongre)  

**Features**:
- Numerical: Sets, Reps, Total Reps
- Categorical: Target Muscle Groups, Equipment Needed, Difficulty Level
- Target Variable: `Burns.Calories..per.30.min.`

**Data Validation & Preprocessing**:
- Verified no missing values or outliers in dataset
- Created boolean columns for muscle groups (Arms, Legs, etc.)
- Added `Equipment.Needed.Bool` flag (TRUE/FALSE)
- Calculated `total_reps = Sets * Reps`
- Standardized difficulty levels (Beginner, Intermediate, Advanced)
- Validated range constraints (e.g., calories between 130-350)

## ⚙️ Technical Approach

### System Requirements
- R version >= 4.1.0
- RAM: 4GB minimum, 8GB recommended
- Storage: 1GB free space
- CPU: Dual-core processor or better

### Dependencies
| Package       | Version | Purpose                |
|--------------|---------|------------------------|
| tidyverse    | >= 1.3.0| Data Wrangling        |
| ggplot2      | >= 3.3.0| Visualization         |
| dplyr        | >= 1.0.0| Data Manipulation     |
| caret        | >= 6.0.0| ML Model Training     |
| randomForest | >= 4.6.0| Random Forest Model   |
| rpart        | >= 4.1.0| Decision Tree Model   |
| rpart.plot   | >= 3.0.0| Tree Visualization    |
| car          | >= 3.0.0| Regression Analysis   |

### Models Implemented
1. **Multiple Linear Regression**  
   - Key predictors: `Legs`, `Chest`, `Difficulty.Level`
   - Assumptions validated: linearity, homoscedasticity, normality
   - VIF analysis performed for multicollinearity

2. **Decision Tree**  
   - Max depth: 10
   - Splitting criteria: CART
   - Min split: 5
   - Complexity parameter: 0.001

3. **Random Forest**  
   - Trees: 1200
   - mtry: 8
   - nodesize: 13
   - maxnodes: 30

## 📈 Results

### Performance Comparison
| Model                | RMSE  | RMSE (% of Mean) | R²    |
|---------------------|-------|------------------|-------|
| Baseline (Mean)     | 53.9  | 23.8%           | 0.00  |
| Linear Regression   | 47.7  | 21.1%           | 0.38  |
| **Decision Tree**   | 36.1  | 16.0%           | 0.58  |
| **Random Forest**   | 34.0  | 15.0%           | 0.72  |

### Visualizations
- Model comparison plots available in `/results/plots/`
- Feature importance analysis in `/results/analysis/`
- Residual diagnostics in `/results/diagnostics/`

## 💻 Installation

1. Verify system requirements:
   ```bash
   R --version  # Should be >= 4.1.0
   ```

2. Clone repository:
   ```bash
   git clone https://github.com/TaylorTurnerIT/Exercise-Data-Group-Project.git
   cd Exercise-Data-Group-Project
   ```

3. Install required R packages:
   ```R
   install.packages(c(
     "tidyverse", 
     "caret", 
     "randomForest", 
     "rpart", 
     "rpart.plot", 
     "ggplot2",
     "car"
   ))
   ```

4. Create required directories:
   ```bash
   mkdir -p results/{plots,analysis,diagnostics}
   ```

## 🚀 Usage

1. Load data and dependencies:
   ```R
   source("exercise_analysis.R")
   ```

2. Run full analysis pipeline:
   ```R
   # Set seed for reproducibility
   set.seed(36698156)
   
   # Perform EDA, model training, and evaluation
   main()
   ```

3. Access model outputs in `/results` directory:
   - Model predictions: `/results/predictions.csv`
   - Performance metrics: `/results/metrics.csv`
   - Visualizations: `/results/plots/`

## ⚠️ Model Limitations
- Limited to 50 exercises in training data
- May not generalize well to novel exercise types
- Assumes standard form and execution
- Performance varies by difficulty level
- Calorie predictions are estimates for average adults

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow tidyverse style guide
- Document all functions
- Include unit tests for new features
- Update documentation as needed

## 🐛 Known Issues
1. Occasional convergence warnings in Random Forest model
2. Linear regression assumes linear relationship between variables
3. Limited validation data for advanced exercises
4. Some muscle group classifications may be oversimplified

## 👥 Contributors
- **Taylor Turner** (EDA, Linear Regression)
  - Contact: [GitHub Profile](https://github.com/TaylorTurnerIT)
- **Gavin Walker** (Decision Trees, Data Transformations)
- **Jonah Perkins** (Random Forest, Model Evaluation)
- **Tristan Martin** (Data Cleaning, Visualization)
- **William Collier** (Feature Engineering)

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📝 Changelog
- v1.0.0 (2024-11-18)
  - Initial release
  - Implemented three prediction models
  - Added basic documentation
  - Created visualization pipeline

## 🙏 Acknowledgments
- Dataset by Prajwal Dongre (Kaggle)
- R community for open-source packages

**🔗 Links**  
- [GitHub Repository](https://github.com/TaylorTurnerIT/Exercise-Data-Group-Project)  
- [Kaggle Dataset](https://www.kaggle.com/datasets/prajwaldongre/best-50-exercise-for-your-body)
- [Issue Tracker](https://github.com/TaylorTurnerIT/Exercise-Data-Group-Project/issues)
