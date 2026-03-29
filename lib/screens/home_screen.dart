import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          // Hero card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.heroGradient,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.psychology, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Claude by Anthropic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Assistant IA avancé, conçu pour être utile, inoffensif et honnête.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          sectionTitle('Qu\'est-ce que Claude ?', context),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.info_outline,
            text: 'Claude est un assistant IA développé par Anthropic. Il est basé sur une architecture de grand modèle de langage (LLM) et formé avec la méthode RLHF (Reinforcement Learning from Human Feedback) et Constitutional AI.',
          ),

          const SizedBox(height: 20),
          sectionTitle('Les modèles disponibles', context),
          const SizedBox(height: 10),
          _ModelCard(
            name: 'Claude Opus 4.6',
            id: 'claude-opus-4-6',
            description: 'Le plus puissant. Idéal pour les tâches complexes.',
            color: context.palette[5],
          ),
          const SizedBox(height: 8),
          _ModelCard(
            name: 'Claude Sonnet 4.6',
            id: 'claude-sonnet-4-6',
            description: 'Équilibre parfait entre performance et vitesse.',
            color: context.palette[2],
          ),
          const SizedBox(height: 8),
          _ModelCard(
            name: 'Claude Haiku 4.5',
            id: 'claude-haiku-4-5-20251001',
            description: 'Ultra rapide et économique pour les tâches simples.',
            color: context.palette[0],
          ),

          const SizedBox(height: 20),
          sectionTitle('Liens utiles', context),
          const SizedBox(height: 10),
          _LinkCard(
            icon: Icons.web,
            label: 'anthropic.com',
            subtitle: 'Site officiel Anthropic',
            url: 'https://www.anthropic.com',
          ),
          const SizedBox(height: 6),
          _LinkCard(
            icon: Icons.description_outlined,
            label: 'docs.anthropic.com',
            subtitle: 'Documentation API',
            url: 'https://docs.anthropic.com',
          ),
          const SizedBox(height: 6),
          _LinkCard(
            icon: Icons.terminal,
            label: 'claude.ai/code',
            subtitle: 'Claude Code CLI',
            url: 'https://claude.ai/code',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ctx.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ctx.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ctx.accentMid, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFCFD8DC), height: 1.6, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String name;
  final String id;
  final String description;
  final Color color;
  const _ModelCard({required this.name, required this.id, required this.description, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.smart_toy_outlined, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(id, style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(color: Color(0xFF90A4AE), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String url;
  const _LinkCard({required this.icon, required this.label, required this.subtitle, required this.url});

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ctx.cardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: ctx.accentMid, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: const TextStyle(color: Color(0xFF78909C), fontSize: 11)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF455A64), size: 14),
          ],
        ),
      ),
    );
  }
}
