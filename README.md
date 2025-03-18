🚀 Stroke Prediction Model Using R

This project builds and deploys a "stroke prediction model" using "R". It applies "machine learning techniques" to predict stroke risk and deploys the model as a "Plumber API".

📌 Project Overview  
- Data Source: "healthcare-dataset-stroke-data.csv"
- Techniques Used:  Data Preprocessing, Feature Engineering, ROSE Balancing  
- Machine Learning Models:  Logistic Regression, SVM, Random Forest  
- Best Model:  Random Forest (`ntree = 200`, `mtry = 3`)  
- Deployment:  Model is saved as `stroke_prediction_model.rds` and used in an API.  

 📊 Dataset & Preprocessing  
 "Categorical variables converted to factors"
 "Missing values in BMI replaced with mean"
 "Data imbalance handled using ROSE (Random Over-Sampling Examples)"
 "Numerical features normalized (age, glucose, BMI)"

🛠️ Model Training & Selection  
Three models were trained and evaluated:  
✅ "Logistic Regression (glmnet)"  
✅ "Support Vector Machine (SVM)"  
✅ "Random Forest (Best Model)"

📈 **Feature Importance Analysis** was performed using "varImpPlot()" to determine the most influential factors.

🌍 API Deployment (Plumber API)  
The trained model is deployed as an "API using Plumber".  

📌 How to Run the API Locally  
1️⃣ Install required libraries:  
   install.packages("plumber")
   library(plumber)

2️⃣ Run the API:
r <- plumb("api.R")
r$run(port = 8000)

3️⃣ Send a POST request to:
http://127.0.0.1:8000/predict

Example JSON Input:
{
  "age": 75,
  "hypertension": 1,
  "heart_disease": 1,
  "avg_glucose_level": 200.0,
  "bmi": 35.0,
  "gender": "Male",
  "ever_married": "Yes",
  "work_type": "Self-employed",
  "Residence_type": "Urban",
  "smoking_status": "smokes"
}
4️⃣ API Response:

{
  "stroke_risk" : "1"
}
This indicates high stroke risk.

📈 Model Performance
🔹 Random Forest achieved the highest accuracy after hyperparameter tuning.
🔹 Balanced dataset using ROSE to improve stroke case detection.
🔹 Evaluated models using confusion matrices to measure precision and recall.

📎 Project Files
📁 stroke-prediction.R – Full training & evaluation script.
📁 api.R – Plumber API for real-time stroke predictions.
📁 stroke_prediction_model.rds – Saved trained model.
📁 train_data_structure.rds – Structure of training data for API input consistency.

👨‍💻 Author
Developed by Santhosh Rao Kudali
📧 Contact: srkudali@gmail.com

🚀 This project aims to assist healthcare professionals in identifying high-risk stroke patients.
