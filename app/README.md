# Smart Scan - Medical Image Analysis Mobile App (Flutter)

A cross-platform Flutter Android mobile application replicating the exact visual UI, glassmorphic styling, and CNN prediction capabilities of the **Smart Scan – Medical Image Analysis Using CNN** portal.

---

## 📱 Features

- **Pixel-Accurate Website Reproduction**:
  - Recreates the exact linear-gradient backgrounds (`rgba(189, 226, 241, 0.95)` to `rgba(209, 249, 241, 0.95)`).
  - Web container border-radius, shadows, input highlights, and dashed upload wrappers.
  - Interactive top navigation bar (`#2c3e50` to `#1a252f`) with active tab indicator.
  - Team member profiles (Abin B, Jeswin Cheriyan PriJi, Vishnu C B, U R Harikesh) and portal footer.
- **CNN Medical Image Prediction**:
  - **MRI Scan Analysis**: Predicts pituitary tumors, meningioma, glioma, or healthy tissue.
  - **CT Scan Analysis**: Predicts renal cyst, kidney stone, tumor, or normal condition.
  - **X-Ray Scan Analysis**: Predicts normal vs. pneumonia condition.
  - Supports single image upload and multi-image grid gallery selection.
  - Genuine API integration with FastAPI (`multipart/form-data`).
  - Automatic response mapping for both `{"predicted_class": int}` (from `app.py`) and `{"prediction": str, "description": str}`.
- **Dynamic Server Configuration**:
  - Centralized in `lib/config/api_config.dart`.
  - Configurable directly from the in-app **Profile & Server Settings** screen without recompilation.
  - Built-in connection tester to verify backend health (`GET /`).
- **Authentication & Security**:
  - JWT token storage backed by `flutter_secure_storage`.
  - Probes backend `/login` and `/register` endpoints.
  - Guest/Researcher mode for testing when backend database endpoints are not yet deployed.
- **Scan History**:
  - Persistent scan logging with date/time, scan modality badge, and thumbnail preview.

---

## 📁 Project Structure

```
mobile_app/
├── lib/
│   ├── main.dart                      # App entry point, theme & route controller
│   ├── config/
│   │   └── api_config.dart            # Centralized API URLs & runtime presets
│   ├── models/
│   │   ├── scan_result.dart           # Scan outcome data model
│   │   ├── user_model.dart            # User profile data model
│   │   └── team_member.dart           # Team bios from index.html
│   ├── services/
│   │   ├── api_service.dart           # HTTP helper & health check
│   │   ├── auth_service.dart          # Secure JWT & login handling
│   │   ├── prediction_service.dart    # CNN multipart inference caller
│   │   └── history_service.dart       # Persistent scan history
│   ├── screens/
│   │   ├── login_screen.dart          # Login & info cards
│   │   ├── register_screen.dart       # User registration
│   │   ├── dashboard_screen.dart      # Main dashboard & tab container
│   │   ├── mri_screen.dart            # MRI analysis page
│   │   ├── ct_screen.dart             # CT scan analysis page
│   │   ├── xray_screen.dart           # X-Ray analysis page
│   │   ├── history_screen.dart        # Saved scans history
│   │   ├── profile_screen.dart        # Server configuration & user profile
│   │   └── about_screen.dart          # About our team
│   ├── widgets/
│   │   ├── web_background.dart        # Medical background image & overlay
│   │   ├── web_container.dart         # Glassmorphic container wrapper
│   │   ├── web_nav_bar.dart           # Dark gradient navigation bar
│   │   ├── web_footer.dart            # Portal copyright footer
│   │   ├── scan_upload_card.dart      # Dashed upload, preview & analysis card
│   │   └── team_member_card.dart      # Team member card widget
│   └── utils/
│       ├── app_colors.dart            # Precise color palette from CSS
│       ├── app_text_styles.dart       # Typography matching web styles
│       └── constants.dart             # Class labels, descriptions & disclaimer
├── android/                           # Native Android configuration
└── pubspec.yaml                       # Dependencies & assets
```

---

## 🚀 How to Run the Flutter Application

### 1. Prerequisites
- **Flutter SDK**: 3.22+ installed and added to `PATH`.
- **Android SDK & Device**: An Android emulator (e.g. Pixel with API 30+) or a physical device connected via USB debugging.

### 2. Install Dependencies
```bash
cd mobile_app
flutter pub get
```

### 3. Run on Android
```bash
flutter run
```

---

## 🔗 Connecting to the FastAPI Backend

The FastAPI backend server runs on `app.py`:

```bash
# In the project root (D:\Smart Scan)
python app.py
```
By default, `app.py` runs at `http://0.0.0.0:5000`.

### Selecting the Correct Backend Base URL in the App:

1. **Android Emulator**:
   - Inside an Android emulator, `localhost` refers to the emulator itself.
   - Use: `http://10.0.2.2:5000`
   - This is configured as the default URL automatically when running on Android.

2. **Physical Android Device**:
   - Ensure your phone and development computer are connected to the same Wi-Fi network.
   - Find your computer's local IP address (e.g. `ipconfig` on Windows -> IPv4 Address, like `192.168.1.50`).
   - Open the **Profile** tab in the Smart Scan app and update the FastAPI Base URL to:
     `http://192.168.1.50:5000`
   - Tap **Save URL** and then **Test Connection**.

3. **Production Server**:
   - Enter `https://your-domain.com` in the Profile settings screen.

---

## 🩺 CNN Prediction Workflow

1. Select a modality tab: **MRI Scan**, **CT Scan**, or **X-Ray Scan**.
2. Tap **Upload Single Image** or **Upload Multiple Images (Grid View)** to pick scans from the device gallery.
3. Review the preview in the container.
4. Tap **Analyze Scan**.
5. The app posts a multipart form to the FastAPI backend (`POST /predict/` or `/predict_mri`, `/predict_ct`, `/predict_xray`).
6. The app parses the genuine CNN classification index/label and displays:
   - Prediction classification badge.
   - Model confidence percentage (if provided by the model).
   - Clinical analysis details.
   - Regulatory medical disclaimer.
   - Saves record into **History**.
