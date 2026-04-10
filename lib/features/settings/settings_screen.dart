import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../core/constants.dart';
import '../../../providers/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _bilingualEnabled = true;
  double _fontSize = 18;
  double _voiceSpeed = 1.0;
  String _language = AppConstants.english;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिंदी'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bilingualEnabled =
          prefs.getBool(AppConstants.keyBilingualEnabled) ?? true;
      _fontSize = prefs.getDouble(AppConstants.keyFontSize) ?? 18;
      _voiceSpeed = prefs.getDouble(AppConstants.keyVoiceSpeed) ?? 1.0;
      _language =
          prefs.getString(AppConstants.keyLanguage) ?? AppConstants.english;
    });
  }

  Future<void> _saveSettings() async {
    final provider = context.read<LanguageProvider>();
    await provider.setLanguage(_language);
    await provider.setFontSize(_fontSize);
    await provider.setVoiceSpeed(_voiceSpeed);
    await provider.setBilingualEnabled(_bilingualEnabled);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Settings saved! • సేవ్ అయ్యాయి! • सहेजा! • சேமிக்கப்பட்டது!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _testVoice() async {
    final provider = context.read<LanguageProvider>();
    final Map<String, String> testTexts = {
      'en': 'Hello! MediLens is ready to help you.',
      'te': 'నమస్కారం! MediLens మీకు సహాయం చేయడానికి సిద్ధంగా ఉంది.',
      'hi': 'नमस्ते! MediLens आपकी मदद के लिए तैयार है।',
      'ta': 'வணக்கம்! MediLens உங்களுக்கு உதவ தயாராக உள்ளது.',
    };
    await provider.speak(testTexts[_language] ?? testTexts['en']!);
  }

  Future<void> _resetApp() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: const Text('Reset App', style: TextStyle(color: AppTheme.white)),
        content: const Text(
          'This will clear all your data.\nమీ డేటా అన్నీ తొలగించబడతాయి.\nआपका सारा डेटा हटा दिया जाएगा।\nஉங்கள் தரவு அனைத்தும் நீக்கப்படும்.',
          style: TextStyle(color: AppTheme.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) context.go(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text('Settings • సెట్టింగులు'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save',
                style: TextStyle(
                    color: AppTheme.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Language Selection
              _buildSectionTitle('Language • భాష • भाषा • மொழி'),
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
              _buildSectionTitle(
                  'Font Size • అక్షర పరిమాణం • फ़ॉन्ट आकार • எழுத்து அளவு'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Text('Sample • నమూనా • नमूना • மாதிரி',
                        style: TextStyle(
                            color: AppTheme.white, fontSize: _fontSize)),
                    Slider(
                      value: _fontSize,
                      min: 14,
                      max: 26,
                      divisions: 3,
                      activeColor: AppTheme.accent,
                      inactiveColor: AppTheme.background,
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
                  'Voice Speed • వాయిస్ వేగం • आवाज़ गति • குரல் வேகம்'),
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
                      inactiveColor: AppTheme.background,
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
              const SizedBox(height: 16),

              // Test Voice Button
              ElevatedButton.icon(
                onPressed: _testVoice,
                icon: const Icon(Icons.volume_up),
                label: const Text(
                    'Test Voice • వాయిస్ పరీక్షించండి • आवाज़ जांचें • குரல் சோதனை'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: 28),

              // Toggles
              _buildToggle(
                'Bilingual Mode • ద్విభాషా మోడ్',
                'Show selected language + English',
                _bilingualEnabled,
                (val) => setState(() => _bilingualEnabled = val),
              ),
              const SizedBox(height: 32),

              // About
              _buildSectionTitle('About • గురించి • के बारे में • பற்றி'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(16)),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('App Version',
                            style: TextStyle(color: AppTheme.grey)),
                        Text('1.0.0', style: TextStyle(color: AppTheme.white)),
                      ],
                    ),
                    Divider(color: AppTheme.background),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Database',
                            style: TextStyle(color: AppTheme.grey)),
                        Text('512,946 medicines',
                            style: TextStyle(color: AppTheme.white)),
                      ],
                    ),
                    Divider(color: AppTheme.background),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Languages',
                            style: TextStyle(color: AppTheme.grey)),
                        Text('EN • TE • HI • TA',
                            style: TextStyle(color: AppTheme.teal)),
                      ],
                    ),
                    Divider(color: AppTheme.background),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Team', style: TextStyle(color: AppTheme.grey)),
                        Text('TECT CLOUDS',
                            style: TextStyle(color: AppTheme.teal)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Reset
              GestureDetector(
                onTap: _resetApp,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: AppTheme.error),
                      SizedBox(width: 8),
                      Text('Reset App • యాప్ రీసెట్ • रीसेट • மீட்டமை',
                          style: TextStyle(
                              color: AppTheme.error,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
