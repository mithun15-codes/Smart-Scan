import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# Set dataset path
dataset_path = "C:/Users/hp/Desktop/Medical_Image_Analysis/x_ray/chest_xray/"

# Image parameters
img_size = (224, 224)
batch_size = 32

# Data augmentation & normalization
train_datagen = ImageDataGenerator(
    rescale=1./255, 
    rotation_range=15, 
    width_shift_range=0.1, 
    height_shift_range=0.1, 
    horizontal_flip=True
)

val_datagen = ImageDataGenerator(rescale=1./255)

# Load train & validation sets
train_generator = train_datagen.flow_from_directory(
    dataset_path + "train",
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary'
)

val_generator = val_datagen.flow_from_directory(
    dataset_path + "val",
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary'
)
