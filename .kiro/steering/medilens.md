---
inclusion: always
---
You are building MediLens — an offline-first Flutter app for elderly and visually impaired
users to scan medicine packaging and get bilingual Telugu+English audio instructions.

TECH STACK: Flutter/Dart, sqflite, google_mlkit_text_recognition,
  google_mlkit_translation, flutter_tts, flutter_local_notifications,
  workmanager, geolocator, url_launcher, go_router, provider, shared_preferences

THEME: Background #0A0F1E  Accent #3B8BEB  Teal #00C9B1  Card #1A2235
ARCHITECTURE: MVVM + Repository pattern.  STATE: Provider.  NAV: go_router.
---
alwaysApply: true
---
OFFLINE-FIRST: drugs.db bundled in assets/, copied on first launch.
  ML Kit models downloaded ONCE on first launch. Everything else 100% offline.

RULES: Always write COMPLETE Dart files. Wrap DB calls in try/catch.
  Every screen shows both English and Telugu. Never hardcode strings.
