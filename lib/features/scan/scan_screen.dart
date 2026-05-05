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
  bool _autoCapture = false;
  String _hint = '';
  String _detectedText = '';
  int _autoCountdown = 3;
  final TextRecognizer _textRecognizer = TextRecognizer();

  final Map<String, String> _hints = {
    'en': 'Align medicine label inside the frame',
    'te': 'మందు లేబుల్ ఫ్రేమ్ లోపల అమర్చండి',
    'hi': 'दवा लेबल को फ्रेम के अंदर रखें',
    'ta': 'மருந்து லேபலை சட்டத்திற்குள் வையுங்கள்',
  };

  final Map<String, String> _scanningText = {
    'en': 'Scanning...',
    'te': 'స్కాన్ చేస్తున్నాము...',
    'hi': 'स्कैन हो रहा है...',
    'ta': 'ஸ்கேன் செய்கிறோம்...',
  };

  final Map<String, String> _detectedText2 = {
    'en': 'Text detected! Auto-capturing in',
    'te': 'టెక్స్ట్ గుర్తించబడింది! స్వయంచాలకంగా',
    'hi': 'टेक्स्ट मिला! ऑटो-कैप्चर',
    'ta': 'உரை கண்டறியப்பட்டது! தானாக',
  };

  final Map<String, String> _noText = {
    'en': 'No medicine label detected. Try again.',
    'te': 'మందు లేబుల్ కనుగొనబడలేదు. మళ్ళీ ప్రయత్నించండి.',
    'hi': 'कोई दवा लेबल नहीं मिला। पुनः प्रयास करें।',
    'ta': 'மருந்து லேபல் கண்டறியப்படவில்லை. மீண்டும் முயற்சிக்கவும்.',
  };

  final Map<String, String> _autoText = {
    'en': 'Auto',
    'te': 'ఆటో',
    'hi': 'ऑटो',
    'ta': 'தானியங்கி',
  };

  final Map<String, String> _manualText = {
    'en': 'Manual',
    'te': 'మాన్యువల్',
    'hi': 'मैन्युअल',
    'ta': 'கையேடு',
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
      if (mounted) setState(() => _isInitialized = true);
      if (_autoCapture) _startAutoDetect();
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  void _startAutoDetect() {
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted || !_autoCapture || _isScanning) return;
      await _quickScan();
      if (mounted && _autoCapture) _startAutoDetect();
    });
  }

  Future<void> _quickScan() async {
    if (!_isInitialized || _cameraController == null) return;
    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final text = recognizedText.text.trim();

      if (text.length > 10) {
        // Good text detected
        setState(() {
          _detectedText = text;
          _autoCountdown = 3;
        });
        _startCountdown();
      } else {
        if (mounted) {
          setState(() => _detectedText = '');
        }
      }
    } catch (e) {
      debugPrint('Quick scan error: $e');
    }
  }

  void _startCountdown() {
    setState(() => _autoCountdown = 3);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _detectedText.isEmpty) return;
      setState(() => _autoCountdown = 2);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted || _detectedText.isEmpty) return;
        setState(() => _autoCountdown = 1);
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted || _detectedText.isEmpty) return;
          _proceedToProcessing(_detectedText);
        });
      });
    });
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
      final scannedText = recognizedText.text.trim();

      if (mounted) {
        if (scannedText.length > 5) {
          _proceedToProcessing(scannedText);
        } else {
          // Nothing detected — show error, stay on scan screen
          setState(() {
            _isScanning = false;
            _hint = _noText[lang] ?? 'No medicine label detected. Try again.';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_noText[lang] ?? 'No medicine label detected.'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
          // Reset hint after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _hint = '');
          });
        }
      }
    } catch (e) {
      debugPrint('Scan error: $e');
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _proceedToProcessing(String text) {
    if (mounted) {
      context.go(AppRoutes.processing, extra: text);
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    setState(() => _flashOn = !_flashOn);
    await _cameraController!.setFlashMode(
      _flashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  void _toggleAutoCapture() {
    setState(() {
      _autoCapture = !_autoCapture;
      _detectedText = '';
    });
    if (_autoCapture) _startAutoDetect();
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

          // Dark overlay with viewfinder
          Positioned.fill(
            child: CustomPaint(painter: _ViewfinderPainter()),
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
                  // Auto/Manual toggle
                  GestureDetector(
                    onTap: _toggleAutoCapture,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _autoCapture
                            ? AppTheme.teal.withValues(alpha: 0.8)
                            : Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                                _autoCapture ? AppTheme.teal : Colors.white30),
                      ),
                      child: Row(
                        children: [
                          Icon(_autoCapture ? Icons.auto_mode : Icons.touch_app,
                              color: AppTheme.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                              _autoCapture
                                  ? (_autoText[lang] ?? 'Auto')
                                  : (_manualText[lang] ?? 'Manual'),
                              style: const TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
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

          // Viewfinder center area
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 260,
                  height: 160,
                  child: Stack(
                    children: [
                      if (_isScanning ||
                          (_autoCapture && _detectedText.isEmpty))
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
                const SizedBox(height: 12),
                // Status hint
                if (_autoCapture && _detectedText.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppTheme.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                            '${_detectedText2[lang] ?? 'Text detected! Auto-capturing in'} $_autoCountdown...',
                            style: const TextStyle(
                                color: AppTheme.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LangText(
                      _hint.isEmpty
                          ? (_hints[lang] ??
                              'Align medicine label inside the frame')
                          : _hint,
                      lang,
                      fontSize: 13,
                      color: _hint.contains('No medicine') ||
                              _hint.contains('కనుగొనబడలేదు') ||
                              _hint.contains('नहीं मिला') ||
                              _hint.contains('கண்டறியப்படவில்லை')
                          ? Colors.orange
                          : AppTheme.teal,
                    ),
                  ),
              ],
            ),
          ),

          // Bottom controls — only show shutter in manual mode
          if (!_autoCapture)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
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
                  const SizedBox(height: 12),
                  Text(
                      _isScanning
                          ? (_scanningText[lang] ?? 'Scanning...')
                          : 'Tap to scan',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),

          // Auto mode indicator at bottom
          if (_autoCapture)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.teal, width: 3),
                      color: AppTheme.teal.withValues(alpha: 0.15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_mode,
                            color: AppTheme.teal, size: 28),
                        Text(_autoText[lang] ?? 'Auto',
                            style: const TextStyle(
                                color: AppTheme.teal,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                      lang == 'te'
                          ? 'స్వయంచాలకంగా గుర్తిస్తోంది...'
                          : lang == 'hi'
                              ? 'स्वचालित रूप से पहचान रहा है...'
                              : lang == 'ta'
                                  ? 'தானாக கண்டறிகிறது...'
                                  : 'Auto detecting medicine label...',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
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

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    final cornerPaint = Paint()
      ..color = AppTheme.teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerLen = 20.0;
    const r = 12.0;

    canvas.drawLine(
        Offset(left + r, top), Offset(left + r + cornerLen, top), cornerPaint);
    canvas.drawLine(
        Offset(left, top + r), Offset(left, top + r + cornerLen), cornerPaint);
    canvas.drawLine(Offset(left + rectWidth - r, top),
        Offset(left + rectWidth - r - cornerLen, top), cornerPaint);
    canvas.drawLine(Offset(left + rectWidth, top + r),
        Offset(left + rectWidth, top + r + cornerLen), cornerPaint);
    canvas.drawLine(Offset(left + r, top + rectHeight),
        Offset(left + r + cornerLen, top + rectHeight), cornerPaint);
    canvas.drawLine(Offset(left, top + rectHeight - r),
        Offset(left, top + rectHeight - r - cornerLen), cornerPaint);
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
