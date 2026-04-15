import 'package:flutter/material.dart';
import 'package:medilens/providers/language_provider.dart';
import 'package:medilens/core/theme.dart';

class LangText extends StatelessWidget {
  final String text;
  final String lang;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  const LangText(
    this.text,
    this.lang, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = AppTheme.white,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: LanguageProvider.getFontFamily(lang),
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
