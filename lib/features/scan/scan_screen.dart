import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';
import 'package:medilens/core/lang_text.dart';
import 'package:medilens/providers/language_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  bool _isScanning = false;
  bool _flashOn = false;
  String _hint = '';
  final TextRecognizer _textRecognizer = TextRecognizer();

  final Map<String, String> _hints = {
    'en': 'Align medicine label here',
    'te': 'మందు లేబుల్ ఇక్కడ అమర్చండి',
    'hi': 'दवा लेबल यहाँ रखें',
    'ta': 'மருந்து லேபலை இங்கே வையுங்கள்',
  };

  final Map<String, String> _scanningText = {
    'en': 'Scanning...',
    'te': 'స్కాన్ చేస్తున్నాము...',
    'hi': 'स्कैन हो रहा है...',
    'ta': 'ஸ்கேன் செய்கிறோம்...',
  };

  final Map<String, String> _scanTitle = {
    'en': 'Scan Medicine',
    'te': 'మందు స్కాన్ చేయండి',
    'hi': 'दवा स्कैन करें',
    'ta': 'மருந்தை ஸ்கேன் செய்யுங்கள்',
  };

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _scan(String lang) async {
    if (_isScanning || !_isInitialized) return;
    setState(() {
      _isScanning = true;
      _hint = _scanningText[lang] ?? 'Scanning...';
    });

    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      String scannedText = recognizedText.text.trim();
      debugPrint('OCR Result: $scannedText');

      if (mounted) {
        // Navigate to processing screen with scanned text
        context.go(AppRoutes.processing, extra: scannedText);
      }
    } catch (e) {
      debugPrint('Scan error: $e');
      if (mounted) {
        setState(() {
          _isScanning = false;
          _hint = _hints[lang] ?? 'Align medicine label here';
        });
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    setState(() => _flashOn = !_flashOn);
    await _cameraController!.setFlashMode(
      _flashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Container(
              color: const Color(0xFF1A1A2E),
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.accent),
              ),
            ),

          // Dark overlay with viewfinder cutout
          Positioned.fill(
            child: CustomPaint(
              painter: _ViewfinderPainter(),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.home),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close,
                          color: AppTheme.white, size: 20),
                    ),
                  ),
                  LangText(_scanTitle[lang] ?? 'Scan Medicine', lang,
                      fontSize: 16, fontWeight: FontWeight.bold),
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _flashOn ? Icons.flash_on : Icons.flash_off,
                        color: _flashOn ? AppTheme.warning : AppTheme.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Viewfinder hint
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Corner markers
                SizedBox(
                  width: 260,
                  height: 160,
                  child: Stack(
                    children: [
                      // Scanning animation
                      if (_isScanning)
                        Positioned.fill(
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(
                                AppTheme.teal.withValues(alpha: 0.6)),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LangText(
                    _hint.isEmpty
                        ? (_hints[lang] ?? 'Align medicine label here')
                        : _hint,
                    lang,
                    fontSize: 13,
                    color: AppTheme.teal,
                  ),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Shutter button
                GestureDetector(
                  onTap: () => _scan(lang),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70, width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isScanning ? AppTheme.grey : AppTheme.white,
                        ),
                        child: _isScanning
                            ? const CircularProgressIndicator(
                                color: AppTheme.accent, strokeWidth: 2)
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LangText(
                  _isScanning
                      ? (_scanningText[lang] ?? 'Scanning...')
                      : 'Tap to scan',
                  lang,
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    const rectWidth = 260.0;
    const rectHeight = 160.0;
    final left = (size.width - rectWidth) / 2;
    final top = (size.height - rectHeight) / 2 - 20;
    final rect = Rect.fromLTWH(left, top, rectWidth, rectHeight);

    // Draw dark overlay with hole
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Draw corner markers
    final cornerPaint = Paint()
      ..color = AppTheme.teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerLen = 20.0;
    const r = 12.0;

    // Top left
    canvas.drawLine(
        Offset(left + r, top), Offset(left + r + cornerLen, top), cornerPaint);
    canvas.drawLine(
        Offset(left, top + r), Offset(left, top + r + cornerLen), cornerPaint);
    // Top right
    canvas.drawLine(Offset(left + rectWidth - r, top),
        Offset(left + rectWidth - r - cornerLen, top), cornerPaint);
    canvas.drawLine(Offset(left + rectWidth, top + r),
        Offset(left + rectWidth, top + r + cornerLen), cornerPaint);
    // Bottom left
    canvas.drawLine(Offset(left + r, top + rectHeight),
        Offset(left + r + cornerLen, top + rectHeight), cornerPaint);
    canvas.drawLine(Offset(left, top + rectHeight - r),
        Offset(left, top + rectHeight - r - cornerLen), cornerPaint);
    // Bottom right
    canvas.drawLine(
        Offset(left + rectWidth - r, top + rectHeight),
        Offset(left + rectWidth - r - cornerLen, top + rectHeight),
        cornerPaint);
    canvas.drawLine(
        Offset(left + rectWidth, top + rectHeight - r),
        Offset(left + rectWidth, top + rectHeight - r - cornerLen),
        cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
