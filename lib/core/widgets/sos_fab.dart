import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medilens/core/theme.dart';
import 'package:medilens/core/routes.dart';

/// Pulsing SOS floating action button.
/// Use as [Scaffold.floatingActionButton] on every screen except Scan & Settings.
class SOSFab extends StatefulWidget {
  const SOSFab({super.key});

  @override
  State<SOSFab> createState() => _SOSFabState();
}

class _SOSFabState extends State<SOSFab> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnim.value,
        child: GestureDetector(
          onTap: () => context.go(AppRoutes.sos),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.error.withValues(alpha: 0.6),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🆘', style: TextStyle(fontSize: 20)),
                Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
