import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final themeNotifier = ValueNotifier<AppTheme>(AppTheme.green);

enum AppTheme { green, orange }

/// Extension pour accéder aux couleurs dynamiques depuis n'importe quel écran
extension AppThemeExt on BuildContext {
  bool get isOrange => themeNotifier.value == AppTheme.orange;

  // Couleurs principales dérivées du thème courant
  Color get primary   => Theme.of(this).colorScheme.primary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get cardBg    => isOrange ? const Color(0xFF2A2018) : const Color(0xFF242424);
  Color get surfaceBg => Theme.of(this).colorScheme.surface;

  // Code blocks
  Color get codeBg     => isOrange ? const Color(0xFF150C05) : const Color(0xFF0D1F0D);
  Color get codeHeader => isOrange ? const Color(0xFF2A1508) : const Color(0xFF1A2E1A);
  Color get codeBorder => isOrange
      ? const Color(0xFFBF5A1A).withValues(alpha: 0.4)
      : const Color(0xFF2E7D32).withValues(alpha: 0.4);
  Color get codeText => isOrange ? const Color(0xFFFFCC80) : const Color(0xFF80CBC4);

  // Accent léger
  Color get accentLight => isOrange ? const Color(0xFFF4A261) : const Color(0xFF66BB6A);
  Color get accentMid   => isOrange ? const Color(0xFFE07530) : const Color(0xFF43A047);

  // Gradient hero
  List<Color> get heroGradient => isOrange
      ? [const Color(0xFF7C2D00), const Color(0xFFBF5A1A), const Color(0xFFE07530)]
      : [const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF388E3C)];

  // Tip card
  Color get tipBg     => isOrange
      ? const Color(0xFF7C2D00).withValues(alpha: 0.3)
      : const Color(0xFF1B5E20).withValues(alpha: 0.3);
  Color get tipBorder => isOrange
      ? const Color(0xFFBF5A1A).withValues(alpha: 0.5)
      : const Color(0xFF2E7D32).withValues(alpha: 0.5);
  Color get tipText   => isOrange ? const Color(0xFFF4A261) : const Color(0xFF81C784);

  // Divider dans drawer
  Color get drawerDivider => isOrange ? const Color(0xFF4A2E10) : const Color(0xFF2E4A2E);

  // Palettes par catégorie (6 couleurs)
  List<Color> get palette => isOrange
      ? const [
          Color(0xFFE07530),
          Color(0xFFD4622E),
          Color(0xFFBF5A1A),
          Color(0xFFE8850A),
          Color(0xFFA0440E),
          Color(0xFF7C2D00),
        ]
      : const [
          Color(0xFF43A047),
          Color(0xFF388E3C),
          Color(0xFF2E7D32),
          Color(0xFF558B2F),
          Color(0xFF33691E),
          Color(0xFF1B5E20),
        ];
}

Widget sectionTitle(String text, BuildContext context) => Text(
      text,
      style: TextStyle(
        color: context.accentLight,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );

/// Code display block with optional labelled header and copy-to-clipboard.
///
/// When [title] is provided the header shows a terminal icon, the title, and
/// a minimal copy icon. When omitted the header shows a labelled copy button.
class CodeBlock extends StatelessWidget {
  final String code;
  final String? title;

  const CodeBlock({required this.code, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.codeBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SelectableText(
              code,
              style: TextStyle(
                color: context.codeText,
                fontFamily: 'monospace',
                fontSize: title != null ? 13 : 12,
                height: title != null ? 1.6 : 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    void onCopy() {
      Clipboard.setData(ClipboardData(text: code));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Copié !'),
        backgroundColor: context.primary,
        duration: const Duration(seconds: 1),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.codeHeader,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: title != null
          ? Row(
              children: [
                Icon(Icons.terminal, size: 14, color: context.accentMid),
                const SizedBox(width: 6),
                Text(title!, style: TextStyle(color: context.accentLight, fontSize: 12)),
                const Spacer(),
                GestureDetector(
                  onTap: onCopy,
                  child: const Icon(Icons.copy, size: 14, color: Color(0xFF546E7A)),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onCopy,
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: 14, color: context.accentMid.withValues(alpha: 0.7)),
                      const SizedBox(width: 4),
                      Text(
                        'Copier',
                        style: TextStyle(
                            color: context.accentMid.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
