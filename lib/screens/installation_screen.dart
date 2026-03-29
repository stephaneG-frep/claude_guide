import 'package:flutter/material.dart';
import '../app_theme.dart';

class InstallationScreen extends StatelessWidget {
  const InstallationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Claude Code CLI', context),
          const SizedBox(height: 10),
          _StepCard(step: '1', title: 'Prérequis : Node.js',
              content: 'Node.js version 18 ou supérieure est requis.'),
          const SizedBox(height: 8),
          CodeBlock(title: 'Vérifier Node.js', code: 'node --version'),
          const SizedBox(height: 16),
          _StepCard(step: '2', title: 'Installer Claude Code',
              content: 'Installe le CLI globalement avec npm.'),
          const SizedBox(height: 8),
          CodeBlock(
              title: 'Installation',
              code: 'npm install -g @anthropic-ai/claude-code'),
          const SizedBox(height: 16),
          _StepCard(step: '3', title: 'Lancer Claude Code',
              content: 'Dans ton répertoire de projet, lance la commande :'),
          const SizedBox(height: 8),
          CodeBlock(title: 'Démarrer', code: 'claude'),
          const SizedBox(height: 24),
          sectionTitle('SDK Python', context),
          const SizedBox(height: 10),
          CodeBlock(title: 'Installation pip', code: 'pip install anthropic'),
          const SizedBox(height: 8),
          CodeBlock(
              title: 'Configuration clé API',
              code: 'export ANTHROPIC_API_KEY="sk-ant-..."'),
          const SizedBox(height: 24),
          sectionTitle('SDK JavaScript / TypeScript', context),
          const SizedBox(height: 10),
          CodeBlock(title: 'Installation npm', code: 'npm install @anthropic-ai/sdk'),
          const SizedBox(height: 24),
          sectionTitle('SDK Dart / Flutter', context),
          const SizedBox(height: 10),
          CodeBlock(title: 'pubspec.yaml', code: 'dependencies:\n  http: ^1.2.0'),
          const SizedBox(height: 20),
          // Tip card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates_outlined, color: context.accentLight, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Obtiens ta clé API sur console.anthropic.com',
                    style: TextStyle(color: context.tipText, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String content;
  const _StepCard({required this.step, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: context.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(step,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 3),
              Text(content, style: const TextStyle(color: Color(0xFF90A4AE), fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

