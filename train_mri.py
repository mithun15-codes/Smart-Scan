import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, Flatten, Dropout
import os

# Define new model path
model_save_path = r"E:\medical-imaging\backend\mri_classification_vgg16_model.h5"

# Ensure dataset path is correct
dataset_path = r"E:\medical-imaging\backend\dataset\mri_scan"
train_dir = os.path.join(dataset_path, "train")
val_dir = os.path.join(dataset_path, "val")

# Image size expected by VGG16
IMG_SIZE = (224, 224)
BATCH_SIZE = 32

# Data Augmentation for better generalization
train_datagen = ImageDataGenerator(
    rescale=1.0/255.0,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True
)

val_datagen = ImageDataGenerator(rescale=1.0/255.0)

# Load training & validation data
train_generator = train_datagen.flow_from_directory(
    train_dir,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

val_generator = val_datagen.flow_from_directory(
    val_dir,
    target_size=IMG_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical'
)

# Load VGG16 base model (without top layers)
base_model = VGG16(weights="imagenet", include_top=False, input_shape=(224, 224, 3))

# Freeze the convolutional base
for layer in base_model.layers:
    layer.trainable = False

# Add custom classifier layers
x = Flatten()(base_model.output)
x = Dense(256, activation='relu')(x)
x = Dropout(0.5)(x)
x = Dense(4, activation='softmax')(x)  # 4 classes

# Create the model
model = Model(inputs=base_model.input, outputs=x)

# Compile the model
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001),
              loss="categorical_crossentropy",
              metrics=["accuracy"])

# Train the model
EPOCHS = 10
history = model.fit(train_generator,
                    validation_data=val_generator,
                    epochs=EPOCHS)

# Save the trained model to the new path
model.save(model_save_path)
print(f"Model saved at: {model_save_path}")
