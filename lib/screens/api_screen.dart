import 'package:flutter/material.dart';
import '../app_theme.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> with SingleTickerProviderStateMixin {
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
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, __) => Column(
        children: [
          Container(
            color: context.isOrange ? const Color(0xFF2A1A0C) : const Color(0xFF1B2E1B),
            child: TabBar(
              controller: _tabController,
              indicatorColor: context.accentMid,
              labelColor: context.accentLight,
              unselectedLabelColor: const Color(0xFF546E7A),
              tabs: const [Tab(text: 'Python'), Tab(text: 'JavaScript'), Tab(text: 'Dart')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_PythonExamples(), _JsExamples(), _DartExamples()],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Python ──────────────────────────────────────────────────────────────────
class _PythonExamples extends StatelessWidget {
  const _PythonExamples();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Appel simple', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''import anthropic

client = anthropic.Anthropic(
    api_key="sk-ant-..."
)

message = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Bonjour Claude !"}
    ]
)

print(message.content[0].text)'''),
          const SizedBox(height: 20),
          _SectionLabel('Avec contexte système', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''message = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    system="Tu es un expert en Python.",
    messages=[
        {"role": "user", "content": "Explique les décorateurs"}
    ]
)'''),
          const SizedBox(height: 20),
          _SectionLabel('Streaming', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''with client.messages.stream(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Raconte une histoire"}],
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)'''),
          const SizedBox(height: 20),
          _SectionLabel('Vision (image)', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''import base64

with open("image.jpg", "rb") as f:
    image_data = base64.b64encode(f.read()).decode()

message = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=1024,
    messages=[{
        "role": "user",
        "content": [
            {
                "type": "image",
                "source": {
                    "type": "base64",
                    "media_type": "image/jpeg",
                    "data": image_data,
                },
            },
            {"type": "text", "text": "Décris cette image"}
        ],
    }]
)'''),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── JavaScript ──────────────────────────────────────────────────────────────
class _JsExamples extends StatelessWidget {
  const _JsExamples();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Appel simple', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''import Anthropic from "@anthropic-ai/sdk";

const client = new Anthropic({
  apiKey: "sk-ant-...",
});

const message = await client.messages.create({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  messages: [
    { role: "user", content: "Bonjour Claude !" }
  ],
});

console.log(message.content[0].text);'''),
          const SizedBox(height: 20),
          _SectionLabel('Streaming', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''const stream = client.messages.stream({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  messages: [{ role: "user", content: "Raconte..." }],
});

for await (const event of stream) {
  if (event.type === "content_block_delta") {
    process.stdout.write(event.delta.text);
  }
}'''),
          const SizedBox(height: 20),
          _SectionLabel('Avec outils (tools)', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''const response = await client.messages.create({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  tools: [{
    name: "get_weather",
    description: "Retourne la météo",
    input_schema: {
      type: "object",
      properties: {
        location: { type: "string" }
      },
      required: ["location"]
    }
  }],
  messages: [{ role: "user", content: "Météo à Paris ?" }],
});'''),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Dart ─────────────────────────────────────────────────────────────────────
class _DartExamples extends StatelessWidget {
  const _DartExamples();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Appel HTTP direct', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> askClaude(String question) async {
  final response = await http.post(
    Uri.parse('https://api.anthropic.com/v1/messages'),
    headers: {
      'x-api-key': 'sk-ant-...',
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    },
    body: jsonEncode({
      'model': 'claude-sonnet-4-6',
      'max_tokens': 1024,
      'messages': [
        {'role': 'user', 'content': question}
      ],
    }),
  );

  final data = jsonDecode(response.body);
  return data['content'][0]['text'];
}'''),
          const SizedBox(height: 20),
          _SectionLabel('Intégration Flutter Widget', context),
          const SizedBox(height: 8),
          CodeBlock(code:'''class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String _response = '';
  bool _loading = false;

  Future<void> _sendMessage(String msg) async {
    setState(() => _loading = true);
    final result = await askClaude(msg);
    setState(() {
      _response = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_loading) const CircularProgressIndicator(),
        Text(_response),
        ElevatedButton(
          onPressed: () => _sendMessage("Bonjour !"),
          child: const Text("Envoyer"),
        ),
      ],
    );
  }
}'''),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Widgets partagés ────────────────────────────────────────────────────────
Widget _SectionLabel(String text, BuildContext context) => Text(
      text,
      style: TextStyle(color: context.accentLight, fontSize: 14, fontWeight: FontWeight.w600),
    );

