# MediLens

> An offline-first bilingual medicine scanning app for elderly and visually impaired rural Indian users.

---

## About

MediLens lets users scan medicine labels, get detailed information in their native language with audio readout, set reminders, track expiry dates, and send emergency SOS alerts — all without internet connectivity.

---

## Features

### Medicine Scanning
- Scan medicine labels using the device camera
- OCR-based text extraction with confidence scoring
- Offline drug database matching via SQLite
- Auto-proceed on high confidence (≥75%)

### Multilingual Support
- Full UI in English, Telugu (తెలుగు), Hindi (हिंदी), Tamil (தமிழ்)
- Bilingual audio readout — your language + English
- Native Noto Sans fonts bundled locally for all 4 scripts
- Language switchable anytime from Settings

### Text-to-Speech
- Voice reminders for medicine names and timings
- Adjustable voice speed — Slow, Normal, Fast
- Expiry voice alerts when medicines near expiry

### Medicine Cabinet
- Save and manage all medicines fully offline
- Search by brand name or generic name
- Filter by expiry status, reminders, or interactions

### Reminders
- Set daily or custom day-of-week reminders
- Mark medicines as taken or not taken
- Voice reminder playback per medicine

### Expiry Tracker
- Overview of valid, expiring soon, and expired medicines
- Visual progress bar per medicine
- Voice alert for expired medicines

### Drug Interaction Checker
- Select multiple medicines to check compatibility
- Results: Safe / Moderate Caution / Dangerous
- Fully offline — no internet required

### Emergency SOS
- Pulsing SOS button always visible on every screen
- Sends SMS + GPS location to registered caregiver instantly
- Voice alert played in the user's language on trigger

### Accessibility
- Adjustable text size — Small, Normal, Large, Extra Large
- High contrast mode
- Large touch targets designed for elderly users
- Voice-first design throughout

---

## Screens

| Screen | Description |
|--------|-------------|
| Welcome | Language selection |
| Personal Details | Name, age, gender, blood group |
| Health Profile | Known conditions and doctor details |
| Caregiver Setup | Emergency contact for SOS |
| Accessibility | Text size, voice speed, toggle settings |
| All Set | Profile summary before entering the app |
| Home | Scan button, quick access cards, today's schedule |
| Scan | Camera viewfinder with scanning animation |
| Processing | Step-by-step OCR processing with confidence score |
| Medicine Info | Detailed drug info with bilingual audio |
| Drug Interaction | Check compatibility between selected medicines |
| Expiry Tracker | Visual expiry overview with alerts |
| Reminders | Today's schedule and all reminders |
| Cabinet | Full medicine list with search and filters |
| SOS | Emergency button with caregiver details |
| Settings | Profile, language, voice and data management |

---

## Tech Stack

| Technology | Usage |
|-----------|-------|
| Flutter | UI framework |
| Dart | Programming language |
| SQLite (sqflite) | Offline drug database |
| flutter_tts | Text-to-speech voice readout |
| go_router | Navigation and routing |
| provider | State management |
| shared_preferences | Local settings storage |
| connectivity_plus | Network status detection |
| Noto Sans Fonts | Multilingual typography |

---

## Project Structure

```
lib/
├── core/
│   ├── constants.dart
│   ├── lang_text.dart          # Multilingual text widget
│   ├── routes.dart
│   └── theme.dart
├── features/
│   ├── cabinet/
│   ├── expiry_tracker/
│   ├── home/
│   ├── interaction_checker/
│   ├── medicine_info/
│   ├── processing/
│   ├── registration/
│   │   └── screens/
│   │       ├── welcome_screen.dart
│   │       ├── personal_details_screen.dart
│   │       ├── health_profile_screen.dart
│   │       ├── caregiver_setup_screen.dart
│   │       ├── accessibility_screen.dart
│   │       └── all_set_screen.dart
│   ├── reminders/
│   ├── scan/
│   ├── settings/
│   └── sos/
├── providers/
│   └── language_provider.dart
├── repositories/
│   └── database_helper.dart
└── main.dart

assets/
├── drugs.db
└── fonts/
    ├── NotoSans-Regular.ttf
    ├── NotoSansTelugu-Regular.ttf
    ├── NotoSansDevanagari-Regular.ttf
    └── NotoSansTamil-Regular.ttf
```

---

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Android Studio or VS Code
- Android device or emulator (API 21+)

### Run

```bash
git clone https://github.com/meghana110506/medilens-app.git
cd medilens-app
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```

---

## Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| Background | `#0A0F1E` | App background |
| Accent | `#3B8BEB` | Primary actions |
| Teal | `#00C9B1` | Secondary, success states |
| Card | `#1A2235` | Cards and containers |
| Error | `#FF5252` | SOS, errors, warnings |

---

## Key Design Decisions

- **Offline-first** — all core features work without internet
- **Voice-first** — every screen supports audio readout
- **Bundled fonts** — Noto Sans fonts bundled locally, no network needed
- **SOS always visible** — pulsing red FAB on every screen for instant access
- **Bilingual output** — medicine info spoken in native language + English simultaneously
- **Large UI** — 70px bottom nav, large buttons, high contrast for elderly users


## 📦 Dataset Sources

The offline drug database (`assets/drugs.db`) was compiled from the following open datasets:

| Dataset | Source | Records | Used For |
|---------|--------|---------|----------|
| Indian Medicine Dataset | [junioralive/Indian-Medicine-Dataset](https://github.com/junioralive/Indian-Medicine-Dataset) | ~14,000 | Indian brand names, manufacturer, price (INR), pack size, composition |
| A-Z Drug Database | [Kaggle](https://www.kaggle.com/) | — | Generic drug names, dosage, side effects, drug class |
| OpenFDA Drug Database | [open.fda.gov](https://open.fda.gov/) | — | Drug interactions, warnings, contraindications |

All datasets are publicly available and used strictly for educational and non-commercial purposes.
