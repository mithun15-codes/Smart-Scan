class AppConstants {
  static const String appTitle = 'Medical Imaging Portal';
  static const String appSubtitle = 'Medical Image Analysis Using CNN';

  // Medical background image from the website
  static const String bgImageUrl =
      'https://www.cdc.gov/vision-health-data/media/images/About-the-data_military_GettyImages-1689003176.jpg';

  // Disclaimer as required by medical applications
  static const String medicalDisclaimer =
      'NOTICE: This analysis is an AI-generated research prediction powered by deep learning CNN models and is provided solely for educational and investigational purposes. It does NOT constitute a confirmed medical diagnosis. Please consult a licensed radiologist or healthcare provider for clinical evaluation.';

  // Scan Modalities
  static const String scanMri = 'mri';
  static const String scanCt = 'ct';
  static const String scanXray = 'xray';

  // Class Names according to evaluate.py
  // MRI: ["pituitary", "notumor", "meningioma", "glioma"]
  static const List<String> mriClasses = [
    'Pituitary Tumor',
    'No Tumor (Normal)',
    'Meningioma',
    'Glioma'
  ];

  // CT: ["Cyst", "Stone", "Tumor", "No Tumor"]
  static const List<String> ctClasses = [
    'Kidney Cyst',
    'Kidney Stone',
    'Tumor Detected',
    'No Tumor (Normal)'
  ];

  // X-Ray: ["Normal", "Pneumonia"]
  static const List<String> xrayClasses = [
    'Normal (Healthy Lung)',
    'Pneumonia Detected'
  ];

  // Descriptions for predicted classes
  static String getClassDescription(String scanType, int classIndex) {
    if (scanType == scanMri) {
      switch (classIndex) {
        case 0:
          return 'The MRI scan displays features indicative of a Pituitary Tumor. Pituitary tumors develop in the pituitary gland at the skull base and can affect hormone secretion or compress the optic chiasm. Immediate clinical correlation and endocrinological consultation are recommended.';
        case 1:
          return 'The MRI scan reveals no signs of abnormal intracranial neoplastic lesions. Brain tissue and ventricular structures appear within normal morphological limits.';
        case 2:
          return 'The MRI scan displays radiological markers characteristic of Meningioma, typically an extra-axial dural-based tumor. Contrast-enhanced neuroimaging review and neurosurgical consultation are advised.';
        case 3:
          return 'The MRI scan indicates findings consistent with Glioma (intra-axial primary brain parenchymal tumor). Further assessment with perfusion MRI, spectroscopy, or biopsy is strongly recommended.';
        default:
          return 'Scan analysis completed by the CNN model.';
      }
    } else if (scanType == scanCt) {
      switch (classIndex) {
        case 0:
          return 'The CT scan demonstrates well-circumscribed, fluid-attenuation areas consistent with Renal Cyst. Most simple cysts are benign (Bosniak I/II); periodic sonographic surveillance is recommended.';
        case 1:
          return 'The CT scan demonstrates hyperdense calcifications characteristic of Nephrolithiasis (Kidney Stone). Clinical correlation with renal function and urological follow-up is recommended.';
        case 2:
          return 'The CT scan demonstrates focal parenchymal tissue mass suspicious for Renal / Abdominal Neoplasm. Multiphase contrast CT and oncology workup are strongly recommended.';
        case 3:
          return 'The CT scan shows clear organ morphology with no hyperdense calculi, cysts, or masses detected. Normal radiological appearance.';
        default:
          return 'CT analysis completed by the CNN model.';
      }
    } else if (scanType == scanXray) {
      switch (classIndex) {
        case 0:
          return 'The Chest X-Ray demonstrates clear bilateral lung fields, normal bronchovascular markings, and crisp costophrenic angles. No pulmonary infiltrates, consolidation, or pleural effusion detected.';
        case 1:
          return 'The Chest X-Ray exhibits opacity and consolidation characteristic of Pneumonia. Clinical evaluation, auscultation, and antimicrobial management by a physician are recommended.';
        default:
          return 'X-Ray analysis completed by the CNN model.';
      }
    }
    return 'Analysis completed.';
  }
}

