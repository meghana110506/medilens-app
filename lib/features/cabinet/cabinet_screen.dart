import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/routes.dart';
import '../../../providers/language_provider.dart';
import '../../../repositories/database_helper.dart';

class CabinetScreen extends StatefulWidget {
  const CabinetScreen({super.key});

  @override
  State<CabinetScreen> createState() => _CabinetScreenState();
}

class _CabinetScreenState extends State<CabinetScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _savedMedicines = [];
  bool _isSearching = false;
  bool _isLoading = false;

  final Map<String, Map<String, String>> _labels = {
    'title': {
      'en': 'Medicine Cabinet',
      'te': 'మందుల క్యాబినెట్',
      'hi': 'दवा कैबिनेट',
      'ta': 'மருந்து அலமாரி'
    },
    'search': {
      'en': 'Search medicines',
      'te': 'మందులు వెతకండి',
      'hi': 'दवाएं खोजें',
      'ta': 'மருந்துகளை தேடுங்கள்'
    },
    'empty': {
      'en': 'Your cabinet is empty',
      'te': 'మీ క్యాబినెట్ ఖాళీగా ఉంది',
      'hi': 'आपकी कैबिनेट खाली है',
      'ta': 'உங்கள் அலமாரி காலியாக உள்ளது'
    },
    'scan_add': {
      'en': 'Scan to Add',
      'te': 'స్కాన్ చేసి జోడించండి',
      'hi': 'जोड़ने के लिए स्कैन करें',
      'ta': 'சேர்க்க ஸ்கேன் செய்யுங்கள்'
    },
    'not_found': {
      'en': 'No medicines found',
      'te': 'మందులు దొరకలేదు',
      'hi': 'कोई दवा नहीं मिली',
      'ta': 'மருந்துகள் கிடைக்கவில்லை'
    },
    'saved': {
      'en': 'saved to cabinet!',
      'te': 'క్యాబినెట్ లో సేవ్ అయింది!',
      'hi': 'कैबिनेट में सहेजा गया!',
      'ta': 'அலமாரியில் சேமிக்கப்பட்டது!'
    },
  };

  String _label(String key, String lang) =>
      _labels[key]?[lang] ?? _labels[key]?['en'] ?? key;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMedicine(String query) async {
    if (query.length < 3) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final db = DatabaseHelper();
      final results = await db.searchDrug(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _saveMedicine(Map<String, dynamic> medicine, String lang) {
    final exists = _savedMedicines.any((m) => m['id'] == medicine['id']);
    if (!exists) {
      setState(() => _savedMedicines.add(medicine));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${medicine['brand_name']} ${_label('saved', lang)}'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  void _removeMedicine(Map<String, dynamic> medicine) {
    setState(
        () => _savedMedicines.removeWhere((m) => m['id'] == medicine['id']));
  }

  Future<void> _speakMedicine(Map<String, dynamic> medicine) async {
    final provider = context.read<LanguageProvider>();
    final lang = provider.language;
    final name = medicine['brand_name'] ?? '';
    final uses = medicine['uses'] ?? '';
    final Map<String, String> texts = {
      'en': 'Medicine: $name. Uses: $uses',
      'te': 'మందు: $name. ఉపయోగాలు: $uses',
      'hi': 'दवा: $name. उपयोग: $uses',
      'ta': 'மருந்து: $name. பயன்கள்: $uses',
    };
    await provider.speak(texts[lang] ?? texts['en']!);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().language;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(_label('title', lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.white),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppTheme.white),
                  onChanged: (val) {
                    setState(() => _isSearching = val.isNotEmpty);
                    _searchMedicine(val);
                  },
                  decoration: InputDecoration(
                    hintText: _label('search', lang),
                    hintStyle: const TextStyle(color: AppTheme.grey),
                    prefixIcon:
                        const Icon(Icons.search, color: AppTheme.accent),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                                _searchResults = [];
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults(lang)
                  : _buildSavedMedicines(lang),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.scan),
        backgroundColor: AppTheme.accent,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchResults(String lang) {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.accent));
    }
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: AppTheme.grey, size: 48),
            const SizedBox(height: 12),
            Text(_label('not_found', lang),
                style: const TextStyle(color: AppTheme.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final medicine = _searchResults[index];
        return _buildMedicineCard(medicine, lang, isSearchResult: true);
      },
    );
  }

  Widget _buildSavedMedicines(String lang) {
    if (_savedMedicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services, color: AppTheme.grey, size: 64),
            const SizedBox(height: 16),
            Text(_label('empty', lang),
                style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(AppRoutes.scan),
              icon: const Icon(Icons.camera_alt),
              label: Text(_label('scan_add', lang)),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _savedMedicines.length,
      itemBuilder: (context, index) {
        final medicine = _savedMedicines[index];
        return _buildMedicineCard(medicine, lang, isSearchResult: false);
      },
    );
  }

  Widget _buildMedicineCard(Map<String, dynamic> medicine, String lang,
      {required bool isSearchResult}) {
    final isSaved = _savedMedicines.any((m) => m['id'] == medicine['id']);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.medication, color: AppTheme.accent, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine['brand_name'] ?? 'Unknown',
                    style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                if (medicine['generic_name'] != null &&
                    medicine['generic_name'].toString().isNotEmpty)
                  Text(medicine['generic_name'],
                      style:
                          const TextStyle(color: AppTheme.grey, fontSize: 12)),
                if (medicine['therapeutic_class'] != null &&
                    medicine['therapeutic_class'].toString().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.teal.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(medicine['therapeutic_class'],
                        style: const TextStyle(
                            color: AppTheme.teal, fontSize: 11)),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _speakMedicine(medicine),
                icon:
                    const Icon(Icons.volume_up, color: AppTheme.teal, size: 20),
              ),
              IconButton(
                onPressed: () => isSearchResult
                    ? _saveMedicine(medicine, lang)
                    : _removeMedicine(medicine),
                icon: Icon(
                  isSearchResult
                      ? (isSaved ? Icons.bookmark : Icons.bookmark_border)
                      : Icons.delete_outline,
                  color: isSearchResult
                      ? (isSaved ? AppTheme.accent : AppTheme.grey)
                      : AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
