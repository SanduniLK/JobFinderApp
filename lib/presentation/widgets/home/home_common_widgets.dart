import 'package:flutter/material.dart';


class Palette {
  static const Color primary = Color(0xFF01BEF9);
  static const Color primaryLight = Color(0xFF66D9FF);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFF43F5E);
  
  static const Color lightBg = Color(0xFFF8F7F4);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF1EFE9);
  static const Color lightBorder = Color(0xFFE8E4D9);
  static const Color lightText = Color(0xFF1C1917);
  static const Color lightTextMuted = Color(0xFF78716C);
  static const Color lightTextFaint = Color(0xFFA8A29E);

  static const Color darkBg = Color(0xFF0F0E0C);
  static const Color darkSurface = Color(0xFF1A1916);
  static const Color darkSurface2 = Color(0xFF242220);
  static const Color darkBorder = Color(0xFF2E2B27);
  static const Color darkText = Color(0xFFFAF8F5);
  static const Color darkTextMuted = Color(0xFF9C9590);
  static const Color darkTextFaint = Color(0xFF5C5752);
}

class HomeTheme {
  final bool isDark;
  const HomeTheme(this.isDark);

  Color get bg => isDark ? Palette.darkBg : Palette.lightBg;
  Color get surface => isDark ? Palette.darkSurface : Palette.lightSurface;
  Color get surface2 => isDark ? Palette.darkSurface2 : Palette.lightSurface2;
  Color get border => isDark ? Palette.darkBorder : Palette.lightBorder;
  Color get text => isDark ? Palette.darkText : Palette.lightText;
  Color get textMuted => isDark ? Palette.darkTextMuted : Palette.lightTextMuted;
  Color get textFaint => isDark ? Palette.darkTextFaint : Palette.lightTextFaint;

  Gradient get headerGradient => isDark
      ? LinearGradient(colors: [Palette.primary, Palette.primary.withOpacity(0.3)])
      : LinearGradient(colors: [Palette.primary, Palette.primaryLight]);
}

class StatPill extends StatelessWidget {
  final IconData icon; final String value; final String label; final Color color;
  const StatPill({required this.icon, required this.value, required this.label, required this.color});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.25))),
    child: Row(children: [Icon(icon, size: 12, color: color), const SizedBox(width: 5), Text('$value $label', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700))]),
  );
}

class ChipButton extends StatelessWidget {
  final String label; final bool isSelected; final HomeTheme theme; final VoidCallback onTap;
  const ChipButton({required this.label, required this.isSelected, required this.theme, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: isSelected ? Palette.primary : theme.surface2, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? Palette.primary : theme.border)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : theme.textMuted)),
    ),
  );
}