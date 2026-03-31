import 'package:flutter/material.dart';
import '../app_theme.dart';

class ClaudeCodeScreen extends StatefulWidget {
  const ClaudeCodeScreen({super.key});

  @override
  State<ClaudeCodeScreen> createState() => _ClaudeCodeScreenState();
}

class _ClaudeCodeScreenState extends State<ClaudeCodeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accentLight;
    return Column(
      children: [
        Container(
          color: context.cardBg,
          child: TabBar(
            controller: _tabController,
            labelColor: accent,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            indicatorColor: accent,
            tabs: const [
              Tab(text: 'Claude Code'),
              Tab(text: 'Projects'),
              Tab(text: 'MCP'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _ClaudeCodeTab(),
              _ProjectsTab(),
              _McpTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab 1 : Claude Code CLI ──────────────────────────────────────────────────

class _ClaudeCodeTab extends StatelessWidget {
  const _ClaudeCodeTab();

  @override
  Widget build(BuildContext context) {
    final c = context.accentLight;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        sectionTitle('Claude Code — Agent de développement', context),
        const SizedBox(height: 8),
        Text(
          'Claude Code est un agent de développement en ligne de commande qui '
          'interagit directement avec votre codebase. Il peut lire, écrire, '
          'exécuter des commandes et naviguer dans des projets complexes de façon autonome.',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5),
        ),
        const SizedBox(height: 16),

        sectionTitle('Installation', context),
        const SizedBox(height: 8),
        const CodeBlock(
          title: 'Prérequis & installation',
          code: '# Node.js 18+ requis\nnpm install -g @anthropic-ai/claude-code\n\n# Vérifier l\'installation\nclaude --version\n\n# Lancer dans un projet\ncd mon-projet\nclaude',
        ),
        const SizedBox(height: 16),

        sectionTitle('Commandes essentielles', context),
        const SizedBox(height: 8),
        ...[
          ('/help', 'Afficher l\'aide et les commandes disponibles'),
          ('/clear', 'Vider l\'historique de la conversation'),
          ('/compact', 'Compresser le contexte pour économiser des tokens'),
          ('/memory', 'Gérer les fichiers CLAUDE.md de mémoire persistante'),
          ('/review', 'Demander une revue de code des changements git'),
          ('/commit', 'Générer un message de commit et commiter'),
          ('/cost', 'Afficher le coût de la session en cours'),
        ].map((e) => _CommandCard(cmd: e.$1, desc: e.$2, color: c)),
        const SizedBox(height: 16),

        sectionTitle('Modes de permission', context),
        const SizedBox(height: 8),
        ...[
          _InfoCard(
            icon: Icons.lock_outline,
            title: 'Mode par défaut',
            body: 'Claude demande confirmation avant chaque action potentiellement '
                'destructive (write, delete, shell). Idéal pour commencer.',
            color: c,
          ),
          _InfoCard(
            icon: Icons.flash_on_outlined,
            title: 'Mode --dangerously-skip-permissions',
            body: 'Exécute toutes les actions sans demander confirmation. '
                'Réservé aux environnements isolés et aux CI/CD pipelines.',
            color: c,
          ),
          _InfoCard(
            icon: Icons.terminal_outlined,
            title: 'Mode non-interactif (-p)',
            body: 'claude -p "Ajoute des tests unitaires au fichier auth.py" '
                'Idéal pour les scripts et les pipelines automatisés.',
            color: c,
          ),
        ],
        const SizedBox(height: 16),

        sectionTitle('Exemple de workflow', context),
        const SizedBox(height: 8),
        const CodeBlock(
          title: 'Session Claude Code typique',
          code: '# Lancer Claude Code dans votre projet\n\$ claude\n\n# Exemples de requêtes\n> Lis le README et explique l\'architecture du projet\n> Trouve tous les bugs dans src/api/auth.js\n> Ajoute la pagination à l\'endpoint /users\n> Écris les tests pour le module payment.py\n> Refactorise la classe UserService pour utiliser des interfaces\n> Crée une PR avec les changements et génère la description',
        ),
        const SizedBox(height: 16),

        sectionTitle('CLAUDE.md — Mémoire persistante', context),
        const SizedBox(height: 8),
        const CodeBlock(
          title: 'CLAUDE.md (à la racine du projet)',
          code: '# Instructions pour Claude Code\n\n## Architecture\n- Backend : FastAPI + PostgreSQL\n- Frontend : React 18 + TypeScript\n- Tests : pytest (coverage > 80%)\n\n## Conventions\n- Nommage snake_case en Python, camelCase en JS\n- Commits au format Conventional Commits\n- Toujours ajouter des types TypeScript\n\n## Commandes utiles\n- `make test` : lancer la suite de tests\n- `make lint` : vérifier le style\n- `make build` : construire le projet',
        ),
      ]),
    );
  }
}

// ── Tab 2 : Projects & Artifacts ─────────────────────────────────────────────

class _ProjectsTab extends StatelessWidget {
  const _ProjectsTab();

  @override
  Widget build(BuildContext context) {
    final c = context.accentLight;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        sectionTitle('Projects — Contexte partagé', context),
        const SizedBox(height: 8),
        Text(
          'Les Projects permettent de partager un contexte commun entre toutes '
          'les conversations d\'un projet. Fichiers, instructions, style de code : '
          'Claude se souvient de tout au fil des sessions.',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5),
        ),
        const SizedBox(height: 16),

        sectionTitle('Fonctionnalités des Projects', context),
        const SizedBox(height: 8),
        ...[
          _InfoCard(
            icon: Icons.folder_outlined,
            title: 'Contexte persistant',
            body: 'Ajoutez des fichiers (code, docs, specs) directement dans votre '
                'project. Claude les garde en mémoire pour toutes les conversations.',
            color: c,
          ),
          _InfoCard(
            icon: Icons.description_outlined,
            title: 'Instructions de projet',
            body: 'Définissez des instructions permanentes : ton, format de réponse, '
                'conventions de code, contraintes métier. Appliquées automatiquement.',
            color: c,
          ),
          _InfoCard(
            icon: Icons.people_outline,
            title: 'Collaboration d\'équipe',
            body: 'Partagez un project avec votre équipe (Claude.ai Teams/Enterprise). '
                'Contexte et fichiers synchronisés pour tous les membres.',
            color: c,
          ),
        ],
        const SizedBox(height: 16),

        sectionTitle('Artifacts — Contenu structuré', context),
        const SizedBox(height: 8),
        Text(
          'Les Artifacts sont des blocs de contenu riches que Claude génère et '
          'affiche dans un panneau dédié : code, documents, SVG, React apps.',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5),
        ),
        const SizedBox(height: 12),
        ...[
          ('Code', Icons.code_outlined, 'Tous les langages avec coloration syntaxique et copie rapide'),
          ('Documents', Icons.article_outlined, 'Markdown rendu, rapports structurés, documentation'),
          ('SVG', Icons.image_outlined, 'Graphiques vectoriels avec prévisualisation instantanée'),
          ('React', Icons.web_outlined, 'Composants React interactifs exécutés dans le navigateur'),
          ('Mermaid', Icons.account_tree_outlined, 'Diagrammes UML, flowcharts, graphes rendus visuellement'),
        ].map((e) => _FeatureRow(label: e.$1, icon: e.$2, desc: e.$3, color: c)),
        const SizedBox(height: 16),

        sectionTitle('Computer Use (Beta)', context),
        const SizedBox(height: 8),
        _InfoCard(
          icon: Icons.computer_outlined,
          title: 'Contrôle d\'interface graphique',
          body: 'Claude peut voir un écran, bouger la souris, cliquer et taper. '
              'Disponible via l\'API avec le modèle claude-3-5-sonnet. '
              'Cas d\'usage : automatisation de tests UI, scraping, workflows desktop.',
          color: c,
        ),
        const SizedBox(height: 8),
        const CodeBlock(
          title: 'Computer Use API',
          code: 'import anthropic\n\nclient = anthropic.Anthropic()\n\nresponse = client.beta.messages.create(\n    model="claude-opus-4-5",\n    max_tokens=1024,\n    tools=[{"type": "computer_20241022",\n             "name": "computer",\n             "display_width_px": 1920,\n             "display_height_px": 1080}],\n    messages=[{"role": "user",\n                "content": "Ouvre le navigateur et recherche Anthropic"}],\n    betas=["computer-use-2024-10-22"],\n)',
        ),
      ]),
    );
  }
}

// ── Tab 3 : MCP ──────────────────────────────────────────────────────────────

class _McpTab extends StatelessWidget {
  const _McpTab();

  @override
  Widget build(BuildContext context) {
    final c = context.accentLight;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        sectionTitle('MCP — Model Context Protocol', context),
        const SizedBox(height: 8),
        Text(
          'Le Model Context Protocol (MCP) est un standard ouvert qui permet '
          'à Claude de se connecter à des sources de données et des outils externes. '
          'Pensez-y comme à un "USB-C pour les LLMs".',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5),
        ),
        const SizedBox(height: 16),

        sectionTitle('Configuration MCP dans Claude Code', context),
        const SizedBox(height: 8),
        const CodeBlock(
          title: '~/.claude/mcp_servers.json',
          code: '{\n  "mcpServers": {\n    "filesystem": {\n      "command": "npx",\n      "args": ["-y", "@modelcontextprotocol/server-filesystem",\n               "/Users/user/projects"]\n    },\n    "github": {\n      "command": "npx",\n      "args": ["-y", "@modelcontextprotocol/server-github"],\n      "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..."}\n    },\n    "postgres": {\n      "command": "npx",\n      "args": ["-y", "@modelcontextprotocol/server-postgres",\n               "postgresql://localhost/mydb"]\n    }\n  }\n}',
        ),
        const SizedBox(height: 16),

        sectionTitle('Serveurs MCP populaires', context),
        const SizedBox(height: 8),
        ...[
          _McpCard(
            icon: Icons.folder_outlined,
            name: 'Filesystem',
            pkg: '@modelcontextprotocol/server-filesystem',
            desc: 'Accès sécurisé aux fichiers locaux avec liste de répertoires autorisés.',
            color: c,
          ),
          _McpCard(
            icon: Icons.code_outlined,
            name: 'GitHub',
            pkg: '@modelcontextprotocol/server-github',
            desc: 'Gestion repos, issues, PRs et code search via l\'API GitHub.',
            color: c,
          ),
          _McpCard(
            icon: Icons.storage_outlined,
            name: 'PostgreSQL',
            pkg: '@modelcontextprotocol/server-postgres',
            desc: 'Connexion directe à une base PostgreSQL pour requêtes en langage naturel.',
            color: c,
          ),
          _McpCard(
            icon: Icons.search_outlined,
            name: 'Brave Search',
            pkg: '@modelcontextprotocol/server-brave-search',
            desc: 'Recherche web en temps réel via l\'API Brave Search.',
            color: c,
          ),
          _McpCard(
            icon: Icons.memory_outlined,
            name: 'Memory',
            pkg: '@modelcontextprotocol/server-memory',
            desc: 'Mémoire persistante cross-sessions via un graphe de connaissances.',
            color: c,
          ),
        ],
        const SizedBox(height: 16),

        sectionTitle('Créer un serveur MCP personnalisé', context),
        const SizedBox(height: 8),
        const CodeBlock(
          title: 'Serveur MCP Python minimal',
          code: 'from mcp.server import Server\nfrom mcp.server.stdio import stdio_server\nfrom mcp import types\n\napp = Server("mon-serveur")\n\n@app.list_tools()\nasync def list_tools() -> list[types.Tool]:\n    return [types.Tool(\n        name="get_meteo",\n        description="Retourne la météo d\'une ville",\n        inputSchema={"type": "object",\n                     "properties": {"ville": {"type": "string"}},\n                     "required": ["ville"]},\n    )]\n\n@app.call_tool()\nasync def call_tool(name: str, arguments: dict):\n    if name == "get_meteo":\n        ville = arguments["ville"]\n        return [types.TextContent(type="text", text=f"Météo à {ville}: 22°C ☀️")]\n\nasync def main():\n    async with stdio_server() as (r, w):\n        await app.run(r, w, app.create_initialization_options())\n\nimport asyncio\nasyncio.run(main())',
        ),
      ]),
    );
  }
}

// ── Widgets partagés ─────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  const _InfoCard({required this.icon, required this.title, required this.body, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 3),
            Text(body,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 12,
                    height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}

class _CommandCard extends StatelessWidget {
  final String cmd;
  final String desc;
  final Color color;

  const _CommandCard({required this.cmd, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5)),
          child: Text(cmd,
              style: TextStyle(
                  color: color, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Text(desc,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 12))),
      ]),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final String desc;
  final Color color;

  const _FeatureRow({required this.label, required this.icon, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        SizedBox(
          width: 68,
          child: Text(label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        Expanded(
            child: Text(desc,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 12))),
      ]),
    );
  }
}

class _McpCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String pkg;
  final String desc;
  final Color color;

  const _McpCard({required this.icon, required this.name, required this.pkg, required this.desc, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(pkg,
                style: TextStyle(
                    color: color.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontFamily: 'monospace')),
            const SizedBox(height: 3),
            Text(desc,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 12,
                    height: 1.4)),
          ]),
        ),
      ]),
    );
  }
}
