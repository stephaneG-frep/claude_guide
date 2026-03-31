import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({super.key});

  static final _apps = [
    _App(
      icon: Icons.chat_bubble_rounded,
      title: 'Claude.ai — Application officielle',
      category: 'Officiel Anthropic',
      description:
          'L\'interface web et mobile officielle d\'Anthropic pour accéder à Claude. '
          'Projects, Artifacts, mémoire persistante et accès aux modèles '
          'Claude Opus, Sonnet et Haiku.',
      tips: [
        'Web : claude.ai (gratuit avec limites, Pro à 20\$/mois)',
        'iOS & Android : application mobile officielle',
        'Projects : contexte partagé entre les conversations',
        'Artifacts : code, SVG, React apps dans un panneau dédié',
        'Plans : Free, Pro, Team (30\$/mois), Enterprise',
      ],
    ),
    _App(
      icon: Icons.terminal_outlined,
      title: 'Claude Code — Agent CLI',
      category: 'Développement',
      description:
          'Agent de développement en ligne de commande qui lit, écrit et exécute '
          'du code directement dans votre projet. Intégré à git, shell '
          'et aux outils de développement.',
      tips: [
        'Installation : npm install -g @anthropic-ai/claude-code',
        'Lancement : cd mon-projet && claude',
        'Mémoire persistante via CLAUDE.md à la racine',
        'Slash commands : /review, /commit, /compact, /memory',
        'Mode non-interactif : claude -p "Ajoute des tests"',
      ],
    ),
    _App(
      icon: Icons.code_outlined,
      title: 'API Anthropic',
      category: 'Développement',
      description:
          'Accès programmatique à tous les modèles Claude via l\'API REST '
          'et les SDKs officiels Python, TypeScript et d\'autres langages. '
          'Streaming, function calling, computer use et vision.',
      tips: [
        'console.anthropic.com pour créer vos clés API',
        'pip install anthropic (Python SDK)',
        'npm install @anthropic-ai/sdk (TypeScript SDK)',
        'Modèles : claude-opus-4-5, claude-sonnet-4-5, claude-haiku-4-5',
        '5\$ de crédits gratuits à l\'inscription',
      ],
    ),
    _App(
      icon: Icons.edit_outlined,
      title: 'Cursor avec Claude',
      category: 'Développement',
      description:
          'Éditeur de code IA basé sur VS Code avec Claude intégré nativement. '
          'Claude Sonnet et Opus disponibles pour le chat, la complétion '
          'et la refactorisation de code.',
      tips: [
        'Téléchargement : cursor.sh',
        'Cursor Settings → Models → sélectionner claude-sonnet ou opus',
        'Raccourci chat : Cmd/Ctrl+K pour le code, Cmd/Ctrl+L pour le chat',
        'Composer : Cmd/Ctrl+I pour les changements multi-fichiers',
        'Plan Pro inclut Claude Opus dans les requêtes premium',
      ],
    ),
    _App(
      icon: Icons.extension_outlined,
      title: 'Continue.dev avec Claude',
      category: 'Développement',
      description:
          'Extension VS Code open source configurée avec l\'API Anthropic. '
          'Utilisez Claude Haiku pour l\'autocomplétion rapide et Claude Sonnet '
          'pour le chat dans votre éditeur.',
      tips: [
        'Extension VS Code : "Continue" dans le marketplace',
        'provider: "anthropic", model: "claude-sonnet-4-5"',
        'Autocomplétion : claude-haiku-4-5 (rapide et économique)',
        'Open source : github.com/continuedev/continue',
        'Support JetBrains, VS Code, Vim/Neovim',
      ],
    ),
    _App(
      icon: Icons.hub_outlined,
      title: 'LangChain + Claude',
      category: 'Frameworks IA',
      description:
          'Intégration native d\'Anthropic dans LangChain pour construire '
          'des pipelines RAG, agents et chaînes complexes. '
          'Compatible LangGraph pour les workflows multi-agents.',
      tips: [
        'pip install langchain-anthropic',
        'ChatAnthropic(model="claude-opus-4-5")',
        'Streaming : .stream() ou .astream() pour les réponses en flux',
        'LangGraph : agents ReAct avec Claude et outils personnalisés',
        'LangSmith : observabilité et tracing des appels Claude',
      ],
    ),
    _App(
      icon: Icons.smart_toy_outlined,
      title: 'Amazon Bedrock + Claude',
      category: 'Cloud Enterprise',
      description:
          'Accédez aux modèles Claude via AWS Bedrock pour les déploiements '
          'enterprise avec sécurité et conformité AWS. '
          'SLA, VPC privé et logs CloudWatch intégrés.',
      tips: [
        'Console AWS → Bedrock → Model access → activer Claude',
        'anthropic.claude-opus-4-5-20251101-v1:0 comme model ID',
        'boto3 client pour l\'accès Python',
        'Conformité SOC2, HIPAA, GDPR via AWS',
        'Bedrock Agents pour les workflows autonomes avec Claude',
      ],
    ),
    _App(
      icon: Icons.psychology_outlined,
      title: 'Google Vertex AI + Claude',
      category: 'Cloud Enterprise',
      description:
          'Claude sur Google Cloud via Vertex AI Model Garden. '
          'Intégration native avec BigQuery, Cloud Storage et les outils GCP. '
          'Idéal pour les équipes déjà sur l\'écosystème Google.',
      tips: [
        'Vertex AI → Model Garden → Anthropic Claude',
        'anthropic[vertex] pour le SDK Python Vertex',
        'AnthropicVertex(region="us-east5") pour l\'initialisation',
        'Grounding avec Google Search disponible',
        'Compatible avec les notebooks Colab et Vertex AI Workbench',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _apps.length,
        itemBuilder: (context, i) => _AppCard(
          app: _apps[i],
          color: context.palette[i % context.palette.length],
        ),
      ),
    );
  }
}

class _AppCard extends StatefulWidget {
  final _App app;
  final Color color;
  const _AppCard({required this.app, required this.color});

  @override
  State<_AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<_AppCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(widget.app.icon, color: c, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.app.title,
                      style: TextStyle(
                          color: c,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(widget.app.category,
                        style: TextStyle(
                            color: c,
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                  color: c, size: 20),
            ]),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(color: c.withValues(alpha: 0.2)),
              Text(widget.app.description,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.5)),
              const SizedBox(height: 10),
              ...widget.app.tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, color: c, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(tip,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                      fontSize: 13))),
                        ]),
                  )),
            ]),
          ),
      ]),
    );
  }
}

class _App {
  final IconData icon;
  final String title;
  final String category;
  final String description;
  final List<String> tips;

  const _App(
      {required this.icon,
      required this.title,
      required this.category,
      required this.description,
      required this.tips});
}
