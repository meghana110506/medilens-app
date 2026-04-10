import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/constants.dart';
import '../../../providers/language_provider.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  String _language = AppConstants.english;
  double _fontSize = 18;
  double _voiceSpeed = 1.0;
  bool _bilingualEnabled = true;
  bool _highContrast = false;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Accessibility'),
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.caregiverSetup),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('అందుబాటు సెట్టింగులు',
                  style: TextStyle(fontSize: 14, color: AppTheme.teal)),
              const SizedBox(height: 4),
              const Text('Accessibility Settings',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white)),
              const SizedBox(height: 8),
              const Text('Customize for your comfort',
                  style: TextStyle(fontSize: 14, color: AppTheme.grey)),
              const SizedBox(height: 32),

              // Language Selection
              _buildSectionTitle('Select Language • భాష ఎంచుకోండి'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: _languages
                    .map((lang) => GestureDetector(
                          onTap: () =>
                              setState(() => _language = lang['code']!),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _language == lang['code']
                                  ? AppTheme.accent
                                  : AppTheme.card,
                              borderRadius: BorderRadius.circular(12),
                              border: _language == lang['code']
                                  ? Border.all(color: AppTheme.accent)
                                  : Border.all(
                                      color: AppTheme.grey.withOpacity(0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lang['native']!,
                                    style: TextStyle(
                                      color: _language == lang['code']
                                          ? AppTheme.white
                                          : AppTheme.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                                Text(lang['name']!,
                                    style: TextStyle(
                                      color: _language == lang['code']
                                          ? AppTheme.white.withOpacity(0.8)
                                          : AppTheme.grey.withOpacity(0.6),
                                      fontSize: 11,
                                    )),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 28),

              // Font Size
              _buildSectionTitle('Font Size • అక్షర పరిమాణం'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Text('Sample Text • నమూనా వచనం • नमूना पाठ • மாதிரி உரை',
                        style: TextStyle(
                            color: AppTheme.white, fontSize: _fontSize)),
                    Slider(
                      value: _fontSize,
                      min: 14,
                      max: 26,
                      divisions: 3,
                      activeColor: AppTheme.accent,
                      inactiveColor: AppTheme.card,
                      onChanged: (val) => setState(() => _fontSize = val),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Small',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 12)),
                        Text('Medium',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 12)),
                        Text('Large',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 12)),
                        Text('X-Large',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Voice Speed
              _buildSectionTitle(
                  'Voice Speed • వాయిస్ వేగం • आवाज़ की गति • குரல் வேகம்'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Slider(
                      value: _voiceSpeed,
                      min: 0.5,
                      max: 1.5,
                      divisions: 2,
                      activeColor: AppTheme.teal,
                      inactiveColor: AppTheme.card,
                      onChanged: (val) => setState(() => _voiceSpeed = val),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Slow\nనెమ్మది\nधीमा\nமெதுவாக',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 11),
                            textAlign: TextAlign.center),
                        Text('Normal\nసాధారణ\nसामान्य\nசாதாரண',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 11),
                            textAlign: TextAlign.center),
                        Text('Fast\nవేగం\nतेज़\nவேகமாக',
                            style:
                                TextStyle(color: AppTheme.grey, fontSize: 11),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Toggles
              _buildToggle(
                'Bilingual Mode',
                'Show selected language + English',
                _bilingualEnabled,
                (val) => setState(() => _bilingualEnabled = val),
              ),
              const SizedBox(height: 12),
              _buildToggle(
                'High Contrast • అధిక వ్యత్యాసం',
                'Easier to read for low vision',
                _highContrast,
                (val) => setState(() => _highContrast = val),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final provider = context.read<LanguageProvider>();
                  await provider.setLanguage(_language);
                  await provider.setFontSize(_fontSize);
                  await provider.setVoiceSpeed(_voiceSpeed);
                  await provider.setBilingualEnabled(_bilingualEnabled);
                  if (context.mounted) context.go(AppRoutes.allSet);
                },
                child: const Text('Next • తదుపరి • अगला • அடுத்து'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            color: AppTheme.grey, fontSize: 14, fontWeight: FontWeight.w500));
  }

  Widget _buildToggle(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppTheme.white, fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: const TextStyle(color: AppTheme.grey, fontSize: 12)),
              ],
            ),
          ),
          Switch(
              value: value, onChanged: onChanged, activeColor: AppTheme.accent),
        ],
      ),
    );
  }
}
