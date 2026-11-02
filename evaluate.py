import numpy as np
import os
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import load_model
from sklearn.metrics import classification_report, confusion_matrix

# Updated model paths
models = {
    "xray": "E:/medical-imaging/backend/x_ray/xray_vgg16.h5",
    "mri": "E:/medical-imaging/backend/mri_classification_vgg16_model.h5",
    "ct": "E:/medical-imaging/backend/medical_vgg16_model.keras"
}

# Test dataset directories
test_dirs = {
    "xray": "E:/medical-imaging/backend/dataset/x_ray/test",
    "mri": "E:/medical-imaging/backend/dataset/mri_scan/val",  # Corrected MRI path
    "ct": "E:/medical-imaging/backend/dataset/ct_scan/val"
}

# Class labels
class_names = {
    "xray": ["Normal", "Pneumonia"],
    "mri": ["pituitary", "notumor", "meningioma", "glioma"],
    "ct": ["Cyst", "Stone", "Tumor", "No Tumor"]
}

def evaluate_model(model_name):
    """Evaluate a model and print performance metrics."""
    if model_name not in models:
        print(f"❌ Error: Invalid model name '{model_name}'. Choose from: xray, mri, or ct.")
        return

    model_path = models[model_name]
    test_dir = test_dirs[model_name]

    # Check if model and test data exist
    if not os.path.exists(model_path):
        print(f"❌ Error: Model file not found: {model_path}")
        return
    if not os.path.exists(test_dir):
        print(f"❌ Error: Test data directory not found: {test_dir}")
        return

    print(f"\n🔹 Loading model for {model_name}...")
    model = load_model(model_path)

    print(f"🔹 Loading test data for {model_name}...")
    img_size = (224, 224)  # Adjust based on model input size
    batch_size = 32

    test_datagen = ImageDataGenerator(rescale=1.0/255)
    test_generator = test_datagen.flow_from_directory(
        test_dir,
        target_size=img_size,
        batch_size=batch_size,
        class_mode="categorical",
        shuffle=False
    )

    print(f"🔹 Evaluating {model_name} model...")
    y_true = test_generator.classes
    y_pred = model.predict(test_generator)
    y_pred_labels = np.argmax(y_pred, axis=1)

    # Compute evaluation metrics
    report = classification_report(y_true, y_pred_labels, target_names=class_names[model_name], digits=4)
    conf_matrix = confusion_matrix(y_true, y_pred_labels)
    accuracy = np.trace(conf_matrix) / np.sum(conf_matrix)  # Accuracy calculation

    print("\n📊 Classification Report:")
    print(report)

    print("\n🖼️ Confusion Matrix:")
    print(conf_matrix)

    print(f"\n✅ Model Accuracy: {accuracy:.4f}")

# Run the evaluation
if __name__ == "__main__":
    model_name = input("\nEnter model name (xray/mri/ct): ").strip().lower()
    evaluate_model(model_name)
