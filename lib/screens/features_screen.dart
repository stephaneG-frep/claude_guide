import 'package:flutter/material.dart';
import '../app_theme.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  static const List<_Feature> _features = [
    _Feature(icon: Icons.visibility_outlined,    title: 'Vision (multimodal)',
      description: 'Claude peut analyser des images, des diagrammes, des captures d\'écran et des documents visuels. Supporte JPEG, PNG, GIF, WebP.',
      tips: ['Envoie une image avec une question précise', 'Utile pour analyser des graphiques, du code en screenshot', 'Peut lire du texte dans les images (OCR)']),
    _Feature(icon: Icons.build_outlined,         title: 'Tool Use (Outils)',
      description: 'Claude peut appeler des fonctions externes que tu définis. Parfait pour connecter Claude à des APIs, bases de données ou services.',
      tips: ['Définis des outils avec un nom, description et schéma JSON', 'Claude décide quand et comment appeler tes outils', 'Idéal pour les agents autonomes']),
    _Feature(icon: Icons.memory_outlined,        title: 'Contexte étendu',
      description: 'Fenêtre de contexte jusqu\'à 200 000 tokens (~150 000 mots). Tu peux envoyer des documents entiers, bases de code, ou longues conversations.',
      tips: ['Envoie tout un codebase pour l\'analyser', 'Résume de longs documents PDF', 'Maintient la cohérence sur de longues conversations']),
    _Feature(icon: Icons.psychology_outlined,    title: 'Constitutional AI',
      description: 'Claude est entraîné avec une "constitution" de principes éthiques. Il refuse les demandes nuisibles et est honnête sur ses limites.',
      tips: ['Claude signale ses incertitudes', 'Refuse les contenus dangereux', 'Explique son raisonnement si demandé']),
    _Feature(icon: Icons.code_outlined,          title: 'Génération de code',
      description: 'Excellent en Python, JavaScript, TypeScript, Dart, Go, Rust, Java et + de 50 langages. Peut déboguer, refactoriser, documenter et tester.',
      tips: ['Précise le langage et le contexte', 'Demande des explications avec le code', 'Utilise pour la revue de code et les tests']),
    _Feature(icon: Icons.translate_outlined,     title: 'Multilingue',
      description: 'Comprend et génère du texte dans des dizaines de langues dont le français, l\'anglais, l\'espagnol, le japonais, le chinois et bien plus.',
      tips: ['Traduit avec nuances culturelles', 'Répond dans la langue que tu utilises', 'Adapte le registre (formel/informel)']),
    _Feature(icon: Icons.smart_toy_outlined,     title: 'Agents autonomes',
      description: 'Avec Claude Code et le SDK Agent, Claude peut exécuter des tâches multi-étapes : lire des fichiers, écrire du code, lancer des commandes.',
      tips: ['Claude Code agit directement dans ton terminal', 'Peut planifier et décomposer des tâches complexes', 'Utilise le SDK pour construire tes propres agents']),
    _Feature(icon: Icons.text_fields_outlined,   title: 'Prompt Caching',
      description: 'Met en cache les parties de prompts répétitives pour réduire les coûts et la latence jusqu\'à 90% sur les requêtes fréquentes.',
      tips: ['Idéal pour les prompts systèmes longs', 'Réduit drastiquement les coûts API', 'Active avec cache_control dans l\'API']),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _features.length,
        itemBuilder: (context, index) {
          final color = context.palette[index % context.palette.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FeatureCard(feature: _features[index], color: color),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final Color color;
  const _FeatureCard({required this.feature, required this.color});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    final c = widget.color;
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(f.icon, color: c, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(f.title,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF546E7A), size: 22),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(f.description,
                  style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 13, height: 1.6)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Conseils',
                      style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  ...f.tips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.arrow_right, color: c, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(tip,
                                  style: const TextStyle(
                                      color: Color(0xFF90A4AE), fontSize: 12, height: 1.5)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final List<String> tips;
  const _Feature({required this.icon, required this.title, required this.description, required this.tips});
}
