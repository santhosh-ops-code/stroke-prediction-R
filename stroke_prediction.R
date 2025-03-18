# =============================
# 🚀 Install Required Packages
# =============================
install.packages(c("caret", "randomForest", "e1071", "pROC", "ggplot2", "glmnet", "ROSE"), dependencies = TRUE)

# =============================
# 🚀 Load Required Libraries
# =============================
library(caret)
library(randomForest)
library(e1071)
library(pROC)
library(ggplot2)
library(glmnet)
library(ROSE)  # Using ROSE instead of SMOTE

# =============================
# 🚀 Load Dataset
# =============================
stroke_data <- read.csv("C:/PROJECTS/Heart_Stroke_File/Stroke/healthcare-dataset-stroke-data.csv", stringsAsFactors = FALSE)

# =============================
# 🚀 Convert Categorical Variables to Factors
# =============================
stroke_data$gender <- as.factor(stroke_data$gender)
stroke_data$ever_married <- as.factor(stroke_data$ever_married)
stroke_data$work_type <- as.factor(stroke_data$work_type)
stroke_data$Residence_type <- as.factor(stroke_data$Residence_type)
stroke_data$smoking_status <- as.factor(stroke_data$smoking_status)
stroke_data$stroke <- as.factor(stroke_data$stroke)  # Ensure stroke is a factor

# =============================
# 🚀 Fix BMI Column (Convert to Numeric)
# =============================
stroke_data$bmi[stroke_data$bmi == "N/A"] <- NA  # Convert "N/A" to NA
stroke_data$bmi <- as.numeric(stroke_data$bmi)   # Convert to numeric safely

# =============================
# 🚀 Handle Missing Values
# =============================
stroke_data$bmi[is.na(stroke_data$bmi)] <- mean(stroke_data$bmi, na.rm = TRUE)  # Replace NA with mean

# =============================
# 🚀 Remove Unnecessary Columns
# =============================
stroke_data$id <- NULL  # Remove ID column (not useful for prediction)

# =============================
# 🚀 Normalize Numerical Variables
# =============================
set.seed(123)
preProcValues <- preProcess(stroke_data[, c("age", "avg_glucose_level", "bmi")], method = c("center", "scale"))
stroke_data[, c("age", "avg_glucose_level", "bmi")] <- predict(preProcValues, stroke_data[, c("age", "avg_glucose_level", "bmi")])

# =============================
# 🚀 Split Data (80% Training, 20% Testing)
# =============================
trainIndex <- createDataPartition(stroke_data$stroke, p = 0.8, list = FALSE)
train_data <- stroke_data[trainIndex, ]
test_data <- stroke_data[-trainIndex, ]

# =============================
# 🚀 Handle Data Imbalance with ROSE
# =============================
print("Before ROSE:")
print(table(train_data$stroke))  # Check distribution of stroke (0 vs 1)

train_data_balanced <- ROSE(stroke ~ ., data = train_data, seed = 1)$data  # Apply ROSE to balance classes

print("After ROSE:")
print(table(train_data_balanced$stroke))  # Check new distribution after ROSE

# =============================
# 🚀 Train Logistic Regression Model with Regularization
# =============================
log_model <- train(stroke ~ ., data = train_data_balanced, method = "glmnet", family = "binomial")

# =============================
# 🚀 Train Random Forest Model with Improved Parameters
# =============================
rf_model <- randomForest(stroke ~ ., data = train_data_balanced, ntree = 200, mtry = 3, importance = TRUE)

# Check feature importance
varImpPlot(rf_model)

# ============================
# 🚀 Train Support Vector Machine (SVM) Model
# =============================
svm_model <- svm(stroke ~ ., data = train_data_balanced, kernel = "linear")

# =============================
# 🚀 Make Predictions
# =============================
log_pred <- predict(log_model, test_data)
rf_pred <- predict(rf_model, test_data, type = "class")
svm_pred <- predict(svm_model, test_data)

# =============================
# 🚀 Ensure Predictions & Actual Values Have Matching Factor Levels
# =============================
log_pred <- factor(log_pred, levels = levels(test_data$stroke))
rf_pred <- factor(rf_pred, levels = levels(test_data$stroke))
svm_pred <- factor(svm_pred, levels = levels(test_data$stroke))

# =============================
# 🚀 Evaluate Models Using Confusion Matrices
# =============================
log_cm <- confusionMatrix(log_pred, test_data$stroke)
rf_cm <- confusionMatrix(rf_pred, test_data$stroke)
svm_cm <- confusionMatrix(svm_pred, test_data$stroke)

# =============================
# 🚀 Print Model Evaluation Results
# =============================
print("Logistic Regression Confusion Matrix:")
print(log_cm)

print("Random Forest Confusion Matrix:")
print(rf_cm)

print("SVM Confusion Matrix:")
print(svm_cm)

# =============================
# 🚀 Save the Trained Model for Deployment
# =============================
saveRDS(rf_model, "C:/PROJECTS/Heart_Stroke_File/Stroke/stroke_prediction_model.rds")
saveRDS(train_data_balanced, "C:/PROJECTS/Heart_Stroke_File/Stroke/train_data_structure.rds")

