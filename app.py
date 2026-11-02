from fastapi import FastAPI, UploadFile, File
import uvicorn
import numpy as np
import tensorflow as tf
from PIL import Image
import io

# Load the model (Update the path to your actual model)
model = tf.keras.models.load_model("../mri_classification_vgg16_model.h5")

app = FastAPI()

# Test Route
@app.get("/")
def read_root():
    return {"message": "API is running"}

# Prediction Route
@app.post("/predict/")
async def predict(file: UploadFile = File(...)):
    try:
        # Read image
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert("RGB")
        image = image.resize((224, 224))  # Resize to match model input

        # Preprocess image
        image_array = np.array(image) / 255.0
        image_array = np.expand_dims(image_array, axis=0)  # Add batch dimension

        # Make prediction
        prediction = model.predict(image_array)
        predicted_class = np.argmax(prediction)

        return {"predicted_class": int(predicted_class)}

    except Exception as e:
        return {"error": str(e)}

# Run the server
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000, reload=True)
