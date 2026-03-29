import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app_theme.dart';

const _playgroundModels = [
  'claude-sonnet-4-6',
  'claude-opus-4-6',
  'claude-haiku-4-5-20251001',
];

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});
  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final _messageController = TextEditingController();
  final _systemController  = TextEditingController(
      text: 'Tu es Claude, un assistant IA développé par Anthropic. Tu réponds de façon claire, concise et utile.');
  final _scrollController  = ScrollController();

  String _selectedModel    = 'claude-sonnet-4-6';
  double _temperature      = 0.7;
  int    _maxTokens        = 1024;
  double _topP             = 1.0;
  bool   _showRawJson      = false;
  bool   _showSystemPrompt = false;

  bool   _isLoading        = false;
  String _response         = '';
  String _rawJson          = '';
  int    _inputTokens      = 0;
  int    _outputTokens     = 0;
  int    _totalTokens      = 0;
  int    _latencyMs        = 0;

  static const _prefKey  = 'anthropic_api_key';
  static const _storage  = FlutterSecureStorage();
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _systemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadKey() async {
    final saved = await _storage.read(key: _prefKey) ?? '';
    if (mounted) setState(() => _apiKey = saved);
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;
    if (_apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Clé API manquante — configurez-la dans Chat Claude'),
        backgroundColor: context.primary,
      ));
      return;
    }

    setState(() {
      _isLoading      = true;
      _response       = '';
      _rawJson        = '';
      _inputTokens    = 0;
      _outputTokens   = 0;
      _totalTokens    = 0;
      _latencyMs      = 0;
    });

    final start = DateTime.now();

    try {
      final response = await http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {
              'x-api-key':         _apiKey,
              'anthropic-version': '2023-06-01',
              'content-type':      'application/json',
            },
            body: jsonEncode({
              'model':      _selectedModel,
              'max_tokens': _maxTokens,
              'temperature': _temperature,
              'top_p':      _topP,
              'system':     _systemController.text.trim(),
              'messages':   [
                {'role': 'user', 'content': text}
              ],
            }),
          )
          .timeout(const Duration(seconds: 60));

      final elapsed = DateTime.now().difference(start).inMilliseconds;

      if (response.statusCode == 200) {
        final data  = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = data['content'][0]['text'] as String;
        final usage = data['usage'] as Map<String, dynamic>?;

        setState(() {
          _response     = reply;
          _rawJson      = const JsonEncoder.withIndent('  ').convert(data);
          _inputTokens  = usage?['input_tokens']  as int? ?? 0;
          _outputTokens = usage?['output_tokens'] as int? ?? 0;
          _totalTokens  = _inputTokens + _outputTokens;
          _latencyMs    = elapsed;
          _isLoading    = false;
        });
      } else {
        final err = jsonDecode(response.body);
        final msg = err['error']?['message'] ?? 'Erreur ${response.statusCode}';
        setState(() {
          _response  = 'Erreur : $msg';
          _rawJson   = const JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
          _latencyMs = elapsed;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response  = 'Erreur réseau : $e';
        _isLoading = false;
      });
    }

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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, _, child) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Modèle
        _label('Modèle', context),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _playgroundModels
              .map((m) => ChoiceChip(
                    label: Text(m,
                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                    selected: _selectedModel == m,
                    onSelected: (_) => setState(() => _selectedModel = m),
                    selectedColor: context.primary.withValues(alpha: 0.25),
                    labelStyle: TextStyle(
                        color: _selectedModel == m
                            ? context.accentLight
                            : const Color(0xFF9E9E9E)),
                    side: BorderSide(
                        color: _selectedModel == m
                            ? context.accentLight
                            : context.codeBorder),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),

        // Paramètres
        _label('Paramètres', context),
        _sliderRow('Temperature', _temperature, _temperature.toStringAsFixed(2),
            0.0, 1.0, 20, (v) => setState(() => _temperature = v), context),
        _sliderRow('Top P', _topP, _topP.toStringAsFixed(2),
            0.0, 1.0, 20, (v) => setState(() => _topP = v), context),
        _sliderRow('Max Tokens', _maxTokens.toDouble(), '$_maxTokens',
            128, 8192, 32, (v) => setState(() => _maxTokens = v.round()), context),
        const SizedBox(height: 16),

        // Prompt système
        GestureDetector(
          onTap: () => setState(() => _showSystemPrompt = !_showSystemPrompt),
          child: Row(
            children: [
              Text('Prompt système',
                  style: TextStyle(
                      color: context.accentLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const SizedBox(width: 6),
              Icon(_showSystemPrompt ? Icons.expand_less : Icons.expand_more,
                  color: context.accentMid, size: 18),
            ],
          ),
        ),
        if (_showSystemPrompt) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _systemController,
            maxLines: 4,
            style: TextStyle(
                color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.codeBg,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.codeBorder)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.codeBorder)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.accentLight)),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Message
        _label('Message', context),
        TextField(
          controller: _messageController,
          maxLines: 5,
          minLines: 3,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Écrivez votre message ici...',
            hintStyle:
                TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            filled: true,
            fillColor: context.cardBg,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.codeBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.codeBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.accentLight)),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _send,
            icon: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.7)),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_isLoading ? 'En cours...' : 'Envoyer',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: context.primary.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Réponse
        if (_response.isNotEmpty) ...[
          Row(
            children: [
              Text('Réponse',
                  style: TextStyle(
                      color: context.accentLight,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const Spacer(),
              if (_totalTokens > 0)
                Text('$_totalTokens tokens · ${_latencyMs}ms',
                    style: TextStyle(
                        color: context.accentMid,
                        fontSize: 11,
                        fontFamily: 'monospace')),
            ],
          ),
          if (_totalTokens > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                _tokenBadge('input', _inputTokens, context.accentMid, context),
                const SizedBox(width: 8),
                _tokenBadge('output', _outputTokens, context.accentLight, context),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.codeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('JSON brut',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 11)),
                        const SizedBox(width: 6),
                        Switch(
                          value: _showRawJson,
                          onChanged: (v) =>
                              setState(() => _showRawJson = v),
                          activeThumbColor: context.accentLight,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                            text: _showRawJson ? _rawJson : _response));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Copié !'),
                              duration: Duration(seconds: 1)),
                        );
                      },
                      child: Icon(Icons.copy, size: 16, color: context.accentMid),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _showRawJson ? _rawJson : _response,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _showRawJson ? 11 : 14,
                    fontFamily: _showRawJson ? 'monospace' : null,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }

  Widget _label(String text, BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(
                color: context.accentLight,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      );

  Widget _sliderRow(String label, double value, String display, double min,
      double max, int divisions, ValueChanged<double> onChanged, BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: context.accentLight,
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(display,
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: context.accentMid,
                  fontFamily: 'monospace',
                  fontSize: 12)),
        ),
      ],
    );
  }

  Widget _tokenBadge(
      String label, int value, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label: $value',
          style: TextStyle(
              color: color, fontSize: 10, fontFamily: 'monospace')),
    );
  }
}
