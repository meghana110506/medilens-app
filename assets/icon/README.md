# App Icon

Place your logo file here as: **logo.png**

Requirements:
- Format: PNG
- Recommended size: 1024x1024 pixels (or at least 512x512)
- Name: logo.png

Steps:
1. Convert your SVG logo to PNG (use https://cloudconvert.com/svg-to-png)
2. Save it as `logo.png` in this folder
3. Run: `flutter pub get`
4. Run: `flutter pub run flutter_launcher_icons`
5. Build APK: `flutter build apk --release`

The flutter_launcher_icons package will automatically generate all required Android icon sizes.
