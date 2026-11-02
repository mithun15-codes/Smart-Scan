# Smart Scan - Medical Image Analysis Using CNN

An end-to-end medical imaging diagnostic system powered by Convolutional Neural Networks (CNNs). The platform provides rapid, automated classification and clinical interpretation for **MRI**, **CT**, and **Chest X-Ray** scans through both a **web-based portal** and a **native Flutter Android mobile application** connected to a **FastAPI** backend.

---

## What is Smart Scan?

Medical image interpretation requires high precision, clinical expertise, and considerable review time. **Smart Scan** assists healthcare practitioners, radiologists, and researchers by delivering rapid, deep learning-assisted classification across three core diagnostic imaging modalities:

### 1. Brain MRI Analysis
Classifies intracranial magnetic resonance images into four diagnostic categories:
- **Pituitary Tumor** - Sellar and suprasellar masses affecting endocrine function or optic chiasm.
- **Meningioma** - Dural-based extra-axial intracranial neoplasms.
- **Glioma** - Primary intra-axial cerebral parenchymal tumors.
- **No Tumor (Healthy)** - Normal morphological structures without focal neoplastic lesions.

### 2. Abdominal & Renal CT Scan Analysis
Screens computed tomography cross-sections for nephrological and abdominal conditions:
- **Kidney Cyst** - Well-demarcated fluid-attenuation renal collections.
- **Kidney Stone (Nephrolithiasis)** - Hyperdense calculi in the renal parenchyma or collecting system.
- **Renal / Parenchymal Tumor** - Suspicious soft-tissue renal neoplasms.
- **No Tumor (Normal)** - Normal organ morphology without calculi, cysts, or masses.

### 3. Chest X-Ray Analysis
Evaluates standard posteroanterior (PA) and anteroposterior (AP) thoracic radiographs:
- **Normal** - Clear bilateral pulmonary fields, crisp costophrenic angles, and normal bronchovascular markings.
- **Pneumonia** - Evidence of alveolar consolidation, airspace opacification, and infiltrates.

---

## Key Features

- **Pixel-Accurate Multi-Platform UI**: Fully synchronized glassmorphic interface across the web browser and Android application with custom gradients, smooth cards, and responsive layouts.
- **Real-Time CNN Inference**: Automated image preprocessing, resizing to 224x224, pixel normalization, and inference via FastAPI REST endpoints.
- **Single & Multi-Image Gallery Uploads**: Supports single diagnostic image uploads or multi-image grid views with interactive preview management.
- **Diagnostic Clinical Breakdown**: Returns prediction labels alongside structured clinical findings and required medical research disclaimers.
- **In-App Dynamic Server Routing**: Switch effortlessly between Android emulator (10.0.2.2:5000), local machine (127.0.0.1:5000), and local Wi-Fi IP (192.168.x.x:5000) with a built-in health-check ping tool.
- **Offline-First Scan History**: Keeps a persistent on-device log of completed scans with timestamps, modality badges, thumbnails, and model findings.
- **Secure Token Storage**: Implements JWT token handling backed by platform-native secure storage (lutter_secure_storage).

---

## Tech Stack

| Component | Technologies & Libraries |
|---|---|
| **Mobile Application** | Flutter 3.44, Dart 3.12, Material 3, image_picker, lutter_secure_storage, shared_preferences, http |
| **Web Frontend** | HTML5, CSS3 Glassmorphism, Vanilla JavaScript (ES6+ Fetch API) |
| **Backend REST API** | Python 3.10+, FastAPI, Uvicorn, Pillow (PIL), NumPy |
| **Deep Learning & AI** | TensorFlow 2.x, Keras, VGG16 (Transfer Learning), Scikit-Learn |
| **Android Build** | Gradle 9.1, Android SDK Platform 35, Kotlin |

---

## Medical Disclaimer

This project is developed for educational, academic, and research purposes only. The classifications provided by the convolutional neural network models do not constitute a certified medical diagnosis. Always consult a licensed radiologist or healthcare provider for clinical evaluation.
