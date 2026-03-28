import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/installation_screen.dart';
import 'screens/api_screen.dart';
import 'screens/prompts_screen.dart';
import 'screens/features_screen.dart';
import 'screens/chat_screen.dart';

// ─── Définition des deux thèmes ──────────────────────────────────────────────
class AppThemes {
  static ThemeData get green => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2E7D32),
          secondary: Color(0xFF43A047),
          surface: Color(0xFF1A1A1A),
          onPrimary: Colors.white,
          onSurface: Color(0xFFE0E0E0),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1B2E1B)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B2E1B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF242424), elevation: 2),
      );

  static ThemeData get orange => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBF5A1A),
          secondary: Color(0xFFE07530),
          surface: Color(0xFF1C1410),
          onPrimary: Colors.white,
          onSurface: Color(0xFFF0E6DC),
        ),
        scaffoldBackgroundColor: const Color(0xFF1C1410),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF2A1A0C)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A1A0C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF2A2018), elevation: 2),
      );
}

// ─── Données des thèmes (couleurs dynamiques pour le drawer) ─────────────────
class ThemeConfig {
  final Color primary;
  final Color accent;
  final Color drawerBg;
  final Color divider;
  final Color selectedTile;
  final Color indicator;
  final Color footerText;
  final List<Color> headerGradient;
  final List<_NavItem> navItems;

  const ThemeConfig({
    required this.primary,
    required this.accent,
    required this.drawerBg,
    required this.divider,
    required this.selectedTile,
    required this.indicator,
    required this.footerText,
    required this.headerGradient,
    required this.navItems,
  });

  static const green = ThemeConfig(
    primary: Color(0xFF2E7D32),
    accent: Color(0xFF66BB6A),
    drawerBg: Color(0xFF1B2E1B),
    divider: Color(0xFF2E4A2E),
    selectedTile: Color(0xFF2E7D32),
    indicator: Color(0xFF66BB6A),
    footerText: Color(0xFF546E7A),
    headerGradient: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
    navItems: [
      _NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFF43A047)),
      _NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFF388E3C)),
      _NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFF2E7D32)),
      _NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFF558B2F)),
      _NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFF33691E)),
      _NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat Claude',     color: Color(0xFF43A047)),
    ],
  );

  static const orange = ThemeConfig(
    primary: Color(0xFFBF5A1A),
    accent: Color(0xFFF4A261),
    drawerBg: Color(0xFF2A1A0C),
    divider: Color(0xFF4A2E10),
    selectedTile: Color(0xFFBF5A1A),
    indicator: Color(0xFFF4A261),
    footerText: Color(0xFF8D6E63),
    headerGradient: [Color(0xFF7C2D00), Color(0xFFBF5A1A), Color(0xFFE07530)],
    navItems: [
      _NavItem(icon: Icons.home_outlined,         label: 'Accueil',         color: Color(0xFFE07530)),
      _NavItem(icon: Icons.download_outlined,     label: 'Installation',    color: Color(0xFFD4622E)),
      _NavItem(icon: Icons.code_outlined,         label: 'API & Code',      color: Color(0xFFBF5A1A)),
      _NavItem(icon: Icons.auto_awesome_outlined, label: 'Prompts',         color: Color(0xFFE8850A)),
      _NavItem(icon: Icons.star_outline,          label: 'Fonctionnalités', color: Color(0xFFA0440E)),
      _NavItem(icon: Icons.chat_bubble_outline,   label: 'Chat Claude',     color: Color(0xFFE07530)),
    ],
  );
}

// ─── App root ────────────────────────────────────────────────────────────────
void main() {
  runApp(const ClaudeGuideApp());
}

class ClaudeGuideApp extends StatelessWidget {
  const ClaudeGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'Claude Guide',
          debugShowCheckedModeBanner: false,
          theme: theme == AppTheme.green ? AppThemes.green : AppThemes.orange,
          home: const MainScaffold(),
        );
      },
    );
  }
}

// ─── Scaffold principal ──────────────────────────────────────────────────────
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    InstallationScreen(),
    ApiScreen(),
    PromptsScreen(),
    FeaturesScreen(),
    ChatScreen(),
  ];

  ThemeConfig get _cfg =>
      themeNotifier.value == AppTheme.green ? ThemeConfig.green : ThemeConfig.orange;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, __) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _cfg.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                _cfg.navItems[_selectedIndex].label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        drawer: _buildDrawer(context),
        body: _screens[_selectedIndex],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final cfg = _cfg;
    final navItems = cfg.navItems;
    final isOrange = themeNotifier.value == AppTheme.orange;

    return Drawer(
      backgroundColor: cfg.drawerBg,
      child: Column(
        children: [
          // Header gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: cfg.headerGradient,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 2),
                  ),
                  child: const Icon(Icons.psychology, size: 38, color: Colors.white),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Claude Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manuel complet Anthropic',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    selected: isSelected,
                    selectedTileColor: cfg.selectedTile.withValues(alpha: 0.22),
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.color.withValues(alpha: 0.28)
                            : item.color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(item.icon,
                          color: isSelected ? Colors.white : item.color,
                          size: 20),
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFFB0BEC5),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    trailing: isSelected
                        ? Container(
                            width: 4,
                            height: 28,
                            decoration: BoxDecoration(
                              color: cfg.indicator,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),

          // Switch thème
          Divider(color: cfg.divider, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.palette_outlined,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.5)),
                const SizedBox(width: 10),
                Text(
                  isOrange ? 'Thème Orange' : 'Thème Vert',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isOrange,
                  onChanged: (val) {
                    themeNotifier.value =
                        val ? AppTheme.orange : AppTheme.green;
                  },
                  activeColor: const Color(0xFFF4A261),
                  activeTrackColor: const Color(0xFFBF5A1A),
                  inactiveThumbColor: const Color(0xFF66BB6A),
                  inactiveTrackColor: const Color(0xFF2E7D32),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              'v1.0 • Claude Anthropic Guide',
              style: TextStyle(
                color: cfg.footerText.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Color color;
  const _NavItem({required this.icon, required this.label, required this.color});
}
