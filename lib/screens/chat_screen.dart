import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController   = TextEditingController();
  final ScrollController      _scrollController = ScrollController();

  String _apiKey   = '';
  bool   _isLoading = false;

  bool get _showKeySetup => _apiKey.isEmpty;

  // Historique affiché (role + content + isLoading)
  final List<_Msg> _display = [];
  // Historique pour l'API (role + content string)
  final List<Map<String, String>> _history = [];

  static const _model    = 'claude-opus-4-6';
  static const _maxTokens = 2048;
  static const _prefKey   = 'anthropic_api_key';
  static const _storage   = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadKey() async {
    final saved = await _storage.read(key: _prefKey) ?? '';
    setState(() => _apiKey = saved);
  }

  Future<void> _saveKey(String key) async {
    await _storage.write(key: _prefKey, value: key.trim());
    setState(() => _apiKey = key.trim());
  }

  Future<void> _deleteKey() async {
    await _storage.delete(key: _prefKey);
    setState(() {
      _apiKey = '';
      _display.clear();
      _history.clear();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _inputController.clear();

    final userMsg = _Msg(role: 'user', content: text);
    final typingMsg = _Msg(role: 'assistant', content: '', isTyping: true);
    setState(() {
      _display.add(userMsg);
      _display.add(typingMsg);
      _isLoading = true;
    });
    _history.add({'role': 'user', 'content': text});
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': _maxTokens,
          'system': 'Tu es Claude, un assistant IA développé par Anthropic. '
              'Tu réponds de façon claire, concise et utile.',
          'messages': _history,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['content'][0]['text'] as String;
        _history.add({'role': 'assistant', 'content': reply});

        setState(() {
          _display.removeLast(); // retire le typing
          _display.add(_Msg(role: 'assistant', content: reply));
          _isLoading = false;
        });
      } else {
        final err = jsonDecode(response.body);
        final errMsg = err['error']?['message'] ?? 'Erreur ${response.statusCode}';
        _history.removeLast(); // retire le message user de l'historique
        setState(() {
          _display.removeLast();
          _display.add(_Msg(role: 'error', content: errMsg));
          _isLoading = false;
        });
      }
    } catch (e) {
      _history.removeLast();
      setState(() {
        _display.removeLast();
        _display.add(_Msg(role: 'error', content: 'Erreur réseau : $e'));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, __) {
        if (_showKeySetup) return _buildKeySetup(context);
        return _buildChat(context);
      },
    );
  }

  // ─── Écran saisie clé API ────────────────────────────────────────────────

  Widget _buildKeySetup(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: context.heroGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.chat_bubble_outline, size: 36, color: Colors.white),
                SizedBox(height: 12),
                Text('Chatbot Claude',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('Entre ta clé API Anthropic pour discuter avec Claude Opus 4.6',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Clé API Anthropic',
              style: TextStyle(color: context.accentLight, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _keyController,
            obscureText: true,
            style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
            decoration: InputDecoration(
              hintText: 'sk-ant-...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              filled: true,
              fillColor: context.cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.primary.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.primary.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.accentMid, width: 1.5),
              ),
              prefixIcon: Icon(Icons.key_outlined, color: context.accentMid, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_keyController.text.trim().isNotEmpty) {
                  _saveKey(_keyController.text);
                }
              },
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Valider'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.tipBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.tipBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: context.accentLight, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Clé disponible sur console.anthropic.com\nStockée localement sur ton appareil.',
                    style: TextStyle(color: context.tipText, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Écran chat ──────────────────────────────────────────────────────────

  Widget _buildChat(BuildContext context) {
    return Column(
      children: [
        // Barre info modèle + bouton reset clé
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          color: context.isOrange ? const Color(0xFF2A1A0C) : const Color(0xFF1B2E1B),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: context.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.smart_toy_outlined, size: 12, color: context.accentLight),
                    const SizedBox(width: 4),
                    Text(_model,
                        style: TextStyle(color: context.accentLight, fontSize: 11, fontFamily: 'monospace')),
                  ],
                ),
              ),
              const Spacer(),
              if (_display.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() {
                    _display.clear();
                    _history.clear();
                  }),
                  child: Icon(Icons.refresh, size: 18, color: Colors.white.withValues(alpha: 0.4)),
                ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _showDeleteKeyDialog(context),
                child: Icon(Icons.key_off_outlined, size: 18, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: _display.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _display.length,
                  itemBuilder: (context, index) => _buildMessage(context, _display[index]),
                ),
        ),

        // Input
        _buildInput(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 56, color: context.primary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Pose ta question à Claude',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 15)),
          const SizedBox(height: 6),
          Text('Modèle : $_model',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, _Msg msg) {
    final isUser  = msg.role == 'user';
    final isError = msg.role == 'error';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            // Avatar Claude
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                color: isError ? const Color(0xFF7C1A1A) : context.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.psychology,
                size: 16, color: Colors.white,
              ),
            ),
          ],

          // Bulle
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? context.primary
                    : isError
                        ? const Color(0xFF4A1010)
                        : context.cardBg,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4  : 16),
                ),
                border: isUser ? null : Border.all(
                  color: isError
                      ? const Color(0xFF7C1A1A)
                      : context.primary.withValues(alpha: 0.2),
                ),
              ),
              child: msg.isTyping
                  ? _TypingIndicator(color: context.accentLight)
                  : SelectableText(
                      msg.content,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white
                            : isError
                                ? const Color(0xFFFF8A80)
                                : const Color(0xFFE0E0E0),
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
            ),
          ),

          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
      decoration: BoxDecoration(
        color: context.isOrange ? const Color(0xFF2A1A0C) : const Color(0xFF1B2E1B),
        border: Border(top: BorderSide(color: context.primary.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message…',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                filled: true,
                fillColor: context.cardBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isLoading
                    ? context.primary.withValues(alpha: 0.4)
                    : context.primary,
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.accentLight,
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.cardBg,
        title: const Text('Changer de clé API', style: TextStyle(color: Colors.white)),
        content: const Text('La conversation sera effacée.',
            style: TextStyle(color: Color(0xFF90A4AE))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: context.accentMid)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteKey();
            },
            child: const Text('Supprimer', style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );
  }
}

// ─── Modèle message ──────────────────────────────────────────────────────────

class _Msg {
  final String role;
  final String content;
  final bool isTyping;
  _Msg({required this.role, required this.content, this.isTyping = false});
}

// ─── Indicateur "en train d'écrire" ─────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  final Color color;
  const _TypingIndicator({required this.color});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
            final opacity = (0.3 + 0.7 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2)).clamp(0.3, 1.0);
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
