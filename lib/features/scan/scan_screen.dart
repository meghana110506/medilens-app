import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isScanning = false;
  bool _flashOn = false;

  Future<void> _scan() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) context.go(AppRoutes.processing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF1A1A2E),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: AppTheme.grey, size: 80),
                  SizedBox(height: 16),
                  Text('Camera Preview',
                      style: TextStyle(color: AppTheme.grey, fontSize: 16)),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.home),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          const Icon(Icons.arrow_back, color: AppTheme.white),
                    ),
                  ),
                  const Text('Scan Medicine',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => setState(() => _flashOn = !_flashOn),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _flashOn ? Icons.flash_on : Icons.flash_off,
                        color: _flashOn ? AppTheme.warning : AppTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 280,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.accent, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isScanning
                      ? const Center(
                          child:
                              CircularProgressIndicator(color: AppTheme.accent))
                      : null,
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isScanning
                        ? 'Scanning...'
                        : 'Point camera at medicine label',
                    style: const TextStyle(color: AppTheme.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _scan,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isScanning ? AppTheme.grey : AppTheme.accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accent.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        )
                      ],
                    ),
                    child: Icon(
                      _isScanning ? Icons.hourglass_empty : Icons.camera_alt,
                      color: AppTheme.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tap to scan',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
