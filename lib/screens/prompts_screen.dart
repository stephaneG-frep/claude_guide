import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';

class PromptsScreen extends StatefulWidget {
  const PromptsScreen({super.key});

  @override
  State<PromptsScreen> createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  String _selectedCategory = 'Tous';

  static const List<_PromptCategory> _categories = [
    _PromptCategory(name: 'Code',         icon: Icons.code,                prompts: [
      _Prompt(title: 'Revue de code',    text: 'Analyse ce code et identifie les bugs, les problèmes de performance et les améliorations possibles :\n\n[COLLER LE CODE ICI]'),
      _Prompt(title: 'Refactoring',      text: 'Refactorise ce code pour le rendre plus lisible, maintenable et performant. Explique chaque changement :\n\n[COLLER LE CODE ICI]'),
      _Prompt(title: 'Tests unitaires',  text: 'Génère des tests unitaires complets pour cette fonction, incluant les cas limites et les cas d\'erreur :\n\n[COLLER LA FONCTION ICI]'),
      _Prompt(title: 'Documentation',    text: 'Génère une documentation complète (docstring, README) pour ce code. Inclus les paramètres, retours et exemples :\n\n[COLLER LE CODE ICI]'),
    ]),
    _PromptCategory(name: 'Écriture',     icon: Icons.edit_note,           prompts: [
      _Prompt(title: 'Améliorer un texte', text: 'Améliore ce texte pour le rendre plus clair, fluide et professionnel, sans changer le sens :\n\n[TEXTE ICI]'),
      _Prompt(title: 'Résumé',           text: 'Résume ce texte en 3 points essentiels, puis donne un résumé court (2-3 phrases) :\n\n[TEXTE ICI]'),
      _Prompt(title: 'Email professionnel', text: 'Rédige un email professionnel pour [SUJET]. Ton : [formel/amical]. Destinataire : [DESTINATAIRE]. Points à inclure : [POINTS]'),
    ]),
    _PromptCategory(name: 'Analyse',      icon: Icons.analytics_outlined,  prompts: [
      _Prompt(title: 'Analyse critique', text: 'Analyse de façon critique et objective ce sujet. Donne les pour, les contre, et ta conclusion :\n\n[SUJET]'),
      _Prompt(title: 'Comparaison',      text: 'Compare [OPTION A] et [OPTION B] selon ces critères : performance, coût, facilité d\'usage, scalabilité. Tableau comparatif puis recommandation.'),
      _Prompt(title: 'Débogage',         text: 'J\'ai cette erreur : [ERREUR]\n\nVoici le code concerné :\n[CODE]\n\nExplique la cause et donne plusieurs solutions.'),
    ]),
    _PromptCategory(name: 'Créativité',   icon: Icons.lightbulb_outline,   prompts: [
      _Prompt(title: 'Brainstorming',    text: 'Génère 10 idées créatives et originales pour [SUJET]. Varie les approches : conventionnelles, disruptives, innovantes.'),
      _Prompt(title: 'Storytelling',     text: 'Écris une histoire courte et engageante sur [THÈME]. Inclus : un personnage mémorable, un conflit, une résolution inattendue.'),
      _Prompt(title: 'Nommage projet',   text: 'Propose 10 noms pour [TYPE DE PROJET]. Critères : mémorable, court, professionnel, disponible comme domaine. Explique chaque choix.'),
    ]),
    _PromptCategory(name: 'Productivité', icon: Icons.check_circle_outline, prompts: [
      _Prompt(title: 'Plan d\'action',   text: 'Crée un plan d\'action détaillé pour atteindre cet objectif : [OBJECTIF]\nDélai : [DÉLAI]\nRessources disponibles : [RESSOURCES]'),
      _Prompt(title: 'Apprendre rapidement', text: 'Je veux apprendre [SUJET] en [DURÉE]. Je suis débutant/intermédiaire/avancé. Crée un plan d\'apprentissage structuré avec ressources.'),
      _Prompt(title: 'Prompt système',   text: 'Tu es un expert en [DOMAINE] avec 20 ans d\'expérience. Tu donnes des réponses précises, structurées et actionnables. Tu demandes des clarifications si nécessaire.'),
    ]),
  ];

  List<_PromptCategory> _filtered = _categories;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, __) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final palette = context.palette;
    final allNames = ['Tous', ..._categories.map((c) => c.name)];

    return Column(
      children: [
        // Filter chips
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: allNames.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final name = allNames[index];
              final isSelected = _selectedCategory == name;
              return FilterChip(
                label: Text(name),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  _selectedCategory = name;
                  _filtered = name == 'Tous' ? _categories : _categories.where((c) => c.name == name).toList();
                }),
                backgroundColor: context.cardBg,
                selectedColor: context.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF90A4AE),
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected ? context.accentMid : const Color(0xFF37474F),
                ),
                showCheckmark: false,
              );
            },
          ),
        ),

        // Prompts list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _filtered.length,
            itemBuilder: (context, catIndex) {
              final category = _filtered[catIndex];
              final color = palette[catIndex % palette.length];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(category.icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(category.name,
                            style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  ...category.prompts.map((prompt) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _PromptCard(prompt: prompt, color: color),
                      )),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PromptCard extends StatefulWidget {
  final _Prompt prompt;
  final Color color;
  const _PromptCard({required this.prompt, required this.color});

  @override
  State<_PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<_PromptCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.prompt.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                      color: const Color(0xFF546E7A), size: 20),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: context.drawerDivider),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    widget.prompt.text,
                    style: const TextStyle(color: Color(0xFFB0BEC5), fontSize: 13, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.prompt.text));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Prompt copié !'),
                          backgroundColor: context.primary,
                          duration: const Duration(seconds: 1),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: widget.color.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.copy, size: 13, color: context.accentLight),
                            const SizedBox(width: 5),
                            Text('Copier le prompt',
                                style: TextStyle(color: context.accentLight, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PromptCategory {
  final String name;
  final IconData icon;
  final List<_Prompt> prompts;
  const _PromptCategory({required this.name, required this.icon, required this.prompts});
}

class _Prompt {
  final String title;
  final String text;
  const _Prompt({required this.title, required this.text});
}
