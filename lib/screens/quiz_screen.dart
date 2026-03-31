import 'package:flutter/material.dart';
import '../app_theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _questions = [
    _Question(
      question: 'Quelle entreprise a créé Claude ?',
      options: ['OpenAI', 'Google DeepMind', 'Anthropic', 'Meta AI'],
      correct: 2,
      explanation: 'Claude est développé par Anthropic, une entreprise fondée en 2021 '
          'par Dario Amodei, Daniela Amodei et d\'autres anciens chercheurs d\'OpenAI. '
          'La mission d\'Anthropic est le développement d\'IA sécurisée.',
    ),
    _Question(
      question: 'Qu\'est-ce que la "Constitutional AI" développée par Anthropic ?',
      options: [
        'Un système de lois pour les robots',
        'Une méthode d\'entraînement IA guidée par un ensemble de principes éthiques',
        'Un algorithme de compression de modèles',
        'Un protocole de communication entre LLMs'
      ],
      correct: 1,
      explanation: 'La Constitutional AI (CAI) est la méthode d\'Anthropic pour entraîner '
          'Claude à être utile, inoffensif et honnête. Le modèle apprend à critiquer '
          'ses propres réponses selon des principes constitutionnels définis.',
    ),
    _Question(
      question: 'Quelle est la fenêtre de contexte de Claude Opus et Sonnet 4 ?',
      options: ['32 000 tokens', '100 000 tokens', '200 000 tokens', '1 000 000 tokens'],
      correct: 2,
      explanation: 'Claude Opus 4 et Sonnet 4 disposent d\'une fenêtre de contexte '
          'de 200 000 tokens, soit environ 150 000 mots ou un livre entier. '
          'Cela permet d\'analyser des codebases et documents volumineux en une seule requête.',
    ),
    _Question(
      question: 'Quelle commande installe le SDK Python officiel d\'Anthropic ?',
      options: [
        'pip install claude-sdk',
        'pip install anthropic',
        'pip install claude-python',
        'pip install anthropic-claude'
      ],
      correct: 1,
      explanation: 'pip install anthropic installe le SDK officiel Python d\'Anthropic. '
          'Importez ensuite avec : import anthropic et créez un client : '
          'client = anthropic.Anthropic(api_key="votre-clé")',
    ),
    _Question(
      question: 'Que signifie MCP dans l\'écosystème Claude ?',
      options: [
        'Multi-Context Processing',
        'Model Context Protocol',
        'Machine Compute Platform',
        'Mistral Communication Protocol'
      ],
      correct: 1,
      explanation: 'MCP (Model Context Protocol) est un standard ouvert créé par Anthropic '
          'permettant à Claude de se connecter à des sources de données et outils externes. '
          'Il fonctionne comme un "USB-C pour les LLMs" : filesystem, GitHub, bases de données...',
    ),
    _Question(
      question: 'Qu\'est-ce que CLAUDE.md dans le contexte de Claude Code ?',
      options: [
        'Un fichier de documentation du projet',
        'Un fichier de configuration de mémoire persistante pour Claude Code',
        'Le fichier de licence d\'Anthropic',
        'Un template de prompts système'
      ],
      correct: 1,
      explanation: 'CLAUDE.md est un fichier de mémoire persistante placé à la racine '
          'du projet. Claude Code le lit automatiquement à chaque session pour connaître '
          'l\'architecture, les conventions de code et les commandes du projet.',
    ),
    _Question(
      question: 'Quel modèle Claude faut-il utiliser pour les tâches de raisonnement les plus complexes ?',
      options: ['claude-haiku-4-5', 'claude-sonnet-4-5', 'claude-opus-4-5', 'claude-instant-1'],
      correct: 2,
      explanation: 'claude-opus-4-5 est le modèle flagship d\'Anthropic, le plus '
          'capable pour les tâches complexes : raisonnement avancé, analyse, '
          'code sophistiqué. Plus lent et coûteux que Sonnet et Haiku.',
    ),
    _Question(
      question: 'Comment installer Claude Code en ligne de commande ?',
      options: [
        'pip install claude-code',
        'npm install -g @anthropic-ai/claude-code',
        'brew install claude',
        'curl -fsSL https://claude.ai/install.sh | sh'
      ],
      correct: 1,
      explanation: 'Claude Code s\'installe via npm avec la commande : '
          'npm install -g @anthropic-ai/claude-code '
          'Il nécessite Node.js 18+. Lancez ensuite claude dans votre projet.',
    ),
    _Question(
      question: 'Qu\'est-ce qu\'un "Artifact" dans Claude.ai ?',
      options: [
        'Un bug ou erreur dans les réponses de Claude',
        'Un fichier de log d\'Anthropic',
        'Un bloc de contenu riche (code, SVG, React) affiché dans un panneau dédié',
        'Un backup de conversation'
      ],
      correct: 2,
      explanation: 'Les Artifacts sont des blocs de contenu structuré que Claude génère '
          'et affiche dans un panneau séparé : code, documents Markdown, SVG, '
          'composants React interactifs, diagrammes Mermaid. Modifiables et réutilisables.',
    ),
    _Question(
      question: 'Quelle commande Claude Code permet de générer un commit git ?',
      options: ['/git', '/save', '/commit', '/push'],
      correct: 2,
      explanation: '/commit génère automatiquement un message de commit basé sur '
          'les changements git en cours, puis effectue le commit. '
          'Claude analyse le diff pour produire un message descriptif.',
    ),
    _Question(
      question: 'Sur quelles plateformes cloud peut-on accéder aux modèles Claude en enterprise ?',
      options: [
        'Uniquement via l\'API Anthropic directe',
        'AWS Bedrock et Google Vertex AI',
        'Microsoft Azure uniquement',
        'Hugging Face uniquement'
      ],
      correct: 1,
      explanation: 'Claude est disponible sur AWS Bedrock et Google Vertex AI '
          'pour les déploiements enterprise, en plus de l\'API Anthropic directe. '
          'Ces plateformes offrent sécurité, conformité et intégration cloud native.',
    ),
    _Question(
      question: 'Quelle est la meilleure approche pour analyser un long document avec Claude ?',
      options: [
        'Découper le document en petits morceaux et faire plusieurs requêtes',
        'Utiliser un résumé du document plutôt que l\'original',
        'Fournir le document entier dans le contexte de 200K tokens',
        'Entraîner un modèle sur le document'
      ],
      correct: 2,
      explanation: 'Grâce à la fenêtre de contexte de 200 000 tokens, Claude peut '
          'analyser des documents entiers (livres, codebases, rapports) en une seule '
          'requête. Cela évite les erreurs de découpage et maintient la cohérence.',
    ),
    _Question(
      question: 'Comment activer le Computer Use de Claude via l\'API ?',
      options: [
        'tools=[{"type": "computer_20241022", ...}] avec le paramètre betas',
        'enable_computer_use=True dans les paramètres',
        'Choisir le modèle claude-computer-use',
        'Computer Use n\'est pas disponible via API'
      ],
      correct: 0,
      explanation: 'Computer Use s\'active en ajoutant tools=[{"type": "computer_20241022", '
          '"name": "computer", "display_width_px": 1920, ...}] et '
          'betas=["computer-use-2024-10-22"] dans l\'appel API avec claude-opus-4-5.',
    ),
    _Question(
      question: 'Quelle est la différence entre claude-haiku et claude-opus ?',
      options: [
        'Haiku est plus grand et plus précis qu\'Opus',
        'Opus est spécialisé pour le code, Haiku pour le texte',
        'Haiku est rapide et économique, Opus est le plus capable mais coûteux',
        'Il n\'y a pas de différence fonctionnelle'
      ],
      correct: 2,
      explanation: 'Claude Haiku est le modèle le plus rapide et économique, '
          'idéal pour les tâches simples et la complétion de code. '
          'Claude Opus est le modèle le plus intelligent, pour les tâches complexes '
          'de raisonnement et d\'analyse, mais avec un coût plus élevé.',
    ),
    _Question(
      question: 'Quelle pratique améliore le plus la qualité des réponses de Claude sur du code ?',
      options: [
        'Demander plusieurs réponses et choisir la meilleure',
        'Fournir le contexte complet : langage, frameworks, contraintes et exemples',
        'Utiliser uniquement des prompts très courts',
        'Commencer toujours par "Tu es un expert en..."'
      ],
      correct: 1,
      explanation: 'Pour le code, fournissez le contexte complet : langage et version, '
          'frameworks utilisés, contraintes (performances, sécurité), le code existant '
          'et le comportement attendu. Plus Claude a de contexte, plus les suggestions '
          'sont précises et directement utilisables.',
    ),
    _Question(
      question: 'Que fait la commande /compact dans Claude Code ?',
      options: [
        'Compresse les fichiers du projet pour réduire leur taille',
        'Compresse l\'historique de conversation pour économiser des tokens de contexte',
        'Minifie le code JavaScript',
        'Crée une archive ZIP du projet'
      ],
      correct: 1,
      explanation: '/compact résume et compresse l\'historique de la conversation '
          'en cours pour libérer de l\'espace dans la fenêtre de contexte. '
          'Utile lors de longues sessions de développement pour éviter de dépasser les limites.',
    ),
  ];

  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  void _answer(int idx) {
    if (_answered) return;
    final correct = _questions[_current].correct == idx;
    setState(() {
      _selected = idx;
      _answered = true;
      if (correct) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    } else {
      setState(() => _finished = true);
    }
  }

  void _restart() {
    setState(() {
      _current = 0;
      _selected = null;
      _answered = false;
      _score = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) =>
          _finished ? _buildResult(context) : _buildQuestion(context),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final q = _questions[_current];
    final accent = context.accentLight;
    final progress = (_current + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${_current + 1}/${_questions.length}',
              style: TextStyle(
                  color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: accent.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(accent),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('Score: $_score',
              style: TextStyle(
                  color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
          ),
          child: Text(q.question,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4)),
        ),
        const SizedBox(height: 16),

        ...List.generate(q.options.length, (i) {
          Color borderColor = accent.withValues(alpha: 0.2);
          Color bgColor = context.cardBg;
          Color textColor = Theme.of(context).colorScheme.onSurface;
          IconData? trailingIcon;

          if (_answered) {
            if (i == q.correct) {
              borderColor = Colors.green;
              bgColor = Colors.green.withValues(alpha: 0.1);
              textColor = Colors.green;
              trailingIcon = Icons.check_circle;
            } else if (i == _selected) {
              borderColor = Colors.red;
              bgColor = Colors.red.withValues(alpha: 0.1);
              textColor = Colors.red;
              trailingIcon = Icons.cancel;
            }
          } else if (_selected == i) {
            borderColor = accent;
            bgColor = accent.withValues(alpha: 0.1);
            textColor = accent;
          }

          return GestureDetector(
            onTap: () => _answer(i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Row(children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      ['A', 'B', 'C', 'D'][i],
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(q.options[i],
                        style: TextStyle(
                            color: textColor, fontSize: 14, height: 1.3))),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: textColor, size: 20),
              ]),
            ),
          );
        }),

        if (_answered) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lightbulb_outline, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(q.explanation,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.5))),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                _current < _questions.length - 1
                    ? 'Question suivante →'
                    : 'Voir le résultat',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildResult(BuildContext context) {
    final accent = context.accentLight;
    final pct = (_score / _questions.length * 100).round();
    final color = pct >= 80
        ? Colors.green
        : pct >= 50
            ? Colors.orange
            : Colors.red;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CircularProgressIndicator(
                  value: _score / _questions.length,
                  strokeWidth: 10,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$_score/${_questions.length}',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text('$pct%',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          Text(
            pct >= 80
                ? 'Excellent ! Vous maîtrisez Claude !'
                : pct >= 50
                    ? 'Bien ! Continuez à explorer Claude.'
                    : 'Révisez le guide et réessayez !',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Score : $_score bonne${_score > 1 ? 's' : ''} réponse${_score > 1 ? 's' : ''} sur ${_questions.length}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh),
              label: const Text('Recommencer le quiz',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;

  const _Question({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}
