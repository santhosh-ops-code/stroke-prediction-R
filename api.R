# Load necessary libraries
library(plumber)
library(randomForest)

# Load trained model and training data structure
model <- readRDS("C:/PROJECTS/Heart_Stroke_File/Stroke/stroke_prediction_model.rds")
train_data <- readRDS("C:/PROJECTS/Heart_Stroke_File/Stroke/train_data_structure.rds")  # Ensure this file exists

#* @post /predict
predict_stroke <- function(age, hypertension, heart_disease, avg_glucose_level, bmi, gender, ever_married, work_type, Residence_type, smoking_status) {
  
  # Convert inputs to correct types
  input_data <- data.frame(
    age = as.numeric(age),
    hypertension = as.integer(hypertension),
    heart_disease = as.integer(heart_disease),
    avg_glucose_level = as.numeric(avg_glucose_level),
    bmi = as.numeric(bmi),
    gender = factor(gender, levels = levels(train_data$gender)),  
    ever_married = factor(ever_married, levels = levels(train_data$ever_married)),
    work_type = factor(work_type, levels = levels(train_data$work_type)),
    Residence_type = factor(Residence_type, levels = levels(train_data$Residence_type)),
    smoking_status = factor(smoking_status, levels = levels(train_data$smoking_status))
  )
  
  # Debugging: Print input structure
  print("🚀 Input Data Structure:")
  print(str(input_data))
  
  # Ensure no NA values in factor columns
  if (any(is.na(input_data))) {
    print("❌ Error: Input contains NA values!")
    return(list(error = "Invalid input: Some categorical values do not match expected levels"))
  }
  
  # Debugging: Check if model is working
  print("⚡ Making Prediction...")
  
  # Make a prediction
  prediction <- tryCatch({
    predict(model, input_data, type = "class")
  }, error = function(e) {
    print("❌ Error: Model prediction failed!")
    print(e)
    return(NULL)
  })
  
  # Debugging: Print prediction result
  print("✅ Prediction Result:")
  print(prediction)
  
  # Return prediction as JSON (Ensuring it returns only the prediction value)
  if (is.null(prediction)) {
    return(list(error = "Prediction failed!"))
  }
  
  # Extract prediction value properly
  prediction_value <- as.character(prediction[[1]])
  
  return(list(stroke_risk = prediction_value))
}