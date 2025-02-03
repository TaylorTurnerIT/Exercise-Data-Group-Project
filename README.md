# Predicting Exercise Effectiveness 🏋️♂️

![GitHub](https://img.shields.io/badge/Language-R-blue)
![GitHub](https://img.shields.io/badge/License-MIT-green)

A machine learning project to predict calorie burn rates for exercises using regression models. Developed as part of a college data analytics course.

## 📖 Table of Contents
- [Problem Statement](#-problem-statement)
- [Dataset](#-dataset)
- [Technical Approach](#-technical-approach)
- [Results](#-results)
- [Installation](#-installation)
- [Usage](#-usage)
- [Contributors](#-contributors)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

---

## 🎯 Problem Statement
The fitness industry lacks accessible tools for predicting exercise effectiveness. This project aims to:
- Build a predictive model for calorie burn rates using exercise attributes (reps, muscle groups, difficulty, etc.).
- Compare performance of **Multiple Linear Regression**, **Decision Trees**, and **Random Forests**.
- Empower fitness enthusiasts to estimate exercise effectiveness without lab testing.

---

## 📊 Dataset
**Source**: [Best 50 Exercises for Your Body](https://www.kaggle.com/datasets/prajwaldongre/best-50-exercise-for-your-body) (Prajwal Dongre)  
**Features**:
- Numerical: Sets, Reps, Total Reps
- Categorical: Target Muscle Groups, Equipment Needed, Difficulty Level
- Target Variable: `Burns.Calories..per.30.min.`

**Preprocessing**:
- Created boolean columns for muscle groups (Arms, Legs, etc.)
- Added `Equipment.Needed.Bool` flag
- Calculated `total_reps = Sets * Reps`

---

## ⚙️ Technical Approach
### Tools & Libraries
| Purpose              | Tools/Packages                              |
|----------------------|---------------------------------------------|
| Data Wrangling       | `tidyverse`, `dplyr`                        |
| Visualization        | `ggplot2`                                   |
| ML Models            | `caret`, `randomForest`, `rpart`, `car`     |
| Model Evaluation     | RMSE, R-Squared                             |

### Models Implemented
1. **Multiple Linear Regression**  
   - Key predictors: `Legs`, `Chest`, `Difficulty.Level`
2. **Decision Tree**  
   - Max depth: 10, Splitting criteria: CART
3. **Random Forest**  
   - 1200 trees, `mtry=8`, `nodesize=13`

---

## 📈 Results
### Performance Comparison
| Model                | RMSE  | RMSE (% of Mean) | R²    |
|----------------------|-------|------------------|-------|
| Baseline (Mean)      | 53.9  | 23.8%            | 0.00  |
| Linear Regression    | 47.7  | 21.1%            | 0.38  |
| **Decision Tree**    | 36.1  | 16.0%            | 0.58  |
| **Random Forest**    | 34.0  | 15.0%            | 0.72  |

### Key Findings
- Random Forest showed best performance (15% error rate)
- Most predictive features:  
  ```Legs (22.3%) > Difficulty Level (18.7%) > total_reps (16.4%)```
- [View Full Analysis Code](https://github.com/TaylorTurnerIT/Exercise-Data-Group-Project)

![Model Comparison](https://via.placeholder.com/600x400.png?text=RMSE+and+R²+Comparison+Plot)

---

## 💻 Installation
1. Clone repository:
   ```bash
   git clone https://github.com/TaylorTurnerIT/Exercise-Data-Group-Project.git
   ```
2. Install required R packages:
   ```R
   install.packages(c("tidyverse", "caret", "randomForest", "rpart", "rpart.plot", "ggplot2"))
   ```

---

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
3. Access model outputs in `/results` directory

---

## 👥 Contributors
- **Taylor Turner** (EDA, Linear Regression)
- **Gavin Walker** (Decision Trees, Data Transformations)
- **Jonah Perkins** (Random Forest, Model Evaluation)
- **Tristan Martin** (Data Cleaning, Visualization)
- **William Collier** (Feature Engineering)

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments
- Dataset by Prajwal Dongre (Kaggle)
- R community for open-source packages

**🔗 Appendix**  
[GitHub Repository](https://github.com/TaylorTurnerIT/Exercise-Data-Group-Project)  
[Kaggle Dataset](https://www.kaggle.com/datasets/prajwaldongre/best-50-exercise-for-your-body)
