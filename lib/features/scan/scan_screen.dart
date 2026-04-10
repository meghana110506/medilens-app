import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';

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
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    setState(() => _flashOn = !_flashOn);
    await _cameraController!
        .setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
  }

  Future<void> _captureAndScan() async {
    if (_cameraController == null || _isScanning) return;
    setState(() => _isScanning = true);
    try {
      final image = await _cameraController!.takePicture();
      if (mounted) {
        context.go(AppRoutes.processing, extra: image.path);
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_isInitialized && _cameraController != null)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            const Center(
                child: CircularProgressIndicator(color: AppTheme.accent)),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.go(AppRoutes.home),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Text(
                    'Scan Medicine\nమందు స్కాన్ చేయండి',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: _toggleFlash,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(_flashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scan Frame
          Center(
            child: Container(
              width: 280,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.accent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Corner decorations
                  Positioned(top: 0, left: 0, child: _corner()),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.scale(scaleX: -1, child: _corner())),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Transform.scale(scaleY: -1, child: _corner())),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Transform.scale(
                          scaleX: -1, scaleY: -1, child: _corner())),
                  if (_isScanning)
                    const Center(
                        child:
                            CircularProgressIndicator(color: AppTheme.accent)),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const Text('Point camera at medicine label',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const Text('మందు లేబుల్ పై కెమెరా పెట్టండి',
                      style: TextStyle(color: Colors.white54, fontSize: 13)),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _captureAndScan,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isScanning ? AppTheme.grey : AppTheme.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.accent.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 4)
                        ],
                      ),
                      child: Icon(
                        _isScanning ? Icons.hourglass_empty : Icons.camera_alt,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Tap to scan • నొక్కి స్కాన్ చేయండి',
                      style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(color: AppTheme.teal, width: 3),
            left: BorderSide(color: AppTheme.teal, width: 3)),
      ),
    );
  }
}
