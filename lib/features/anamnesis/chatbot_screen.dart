import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme/colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'sender': 'AylluCare AI',
      'text': '¡Hola! Soy AylluAI. Cuéntame tus síntomas o motivo de consulta.'
    }
  ];

  bool _isLoading = false;

  List<Map<String, String>> _buildChatHistory() {
    return _messages.map((msg) {
      return {
        "role": msg["role"] ?? "user",
        "content": msg["text"] ?? ""
      };
    }).toList();
  }

  //enviar mensajes
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'sender': 'Tú',
        'text': message,
      });
      _isLoading = true;
      _controller.clear();
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer 'TU_CLAVE_SECRETA_REAL_AQUI'",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {
              "role": "system",
              "content": """
Eres AylluAI, un asistente médico profesional.

REGLAS IMPORTANTES:
1. Mantén coherencia con los síntomas ya mencionados.
2. Nunca vuelvas a preguntar sobre síntomas ya dados.
3. Si el usuario ya dijo que duele X parte del cuerpo, NO preguntes dónde duele.
4. Haz preguntas guiadas y médicas, no genéricas.
5. Mantén un tono humano y empático.
"""
            },
            ..._buildChatHistory(),
          ],
          "temperature": 0.4,
          "max_tokens": 200
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];

        setState(() {
          _messages.add({
            'role': 'assistant',
            'sender': 'AylluCare AI',
            'text': reply,
          });
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'sender': 'AylluCare AI',
            'text': "Lo siento, ocurrió un error. Código: ${response.statusCode}"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'sender': 'AylluCare AI',
          'text': "Error de conexión. ¿Tienes internet?"
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  //para finalizar evaluacion
  Future<void> _finishEvaluation() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final userMessages = _messages
        .where((msg) => msg["role"] == "user")
        .map((m) => m["text"])
        .join("\n");

    try {
      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer 'TU_CLAVE_SECRETA_REAL_AQUI'",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {
              "role": "system",
              "content": """
Eres un asistente médico especializado en triaje temprano.

Debes analizar TODOS los síntomas proporcionados por el usuario.

TAREAS:
1. Resume el caso médico en máximo 4 líneas.
2. Clasifica el riesgo según:
   - **BAJO**: síntomas leves y sin señales de peligro.
   - **MODERADO**: síntomas preocupantes pero no urgentes.
   - **CRÍTICO**: dificultad para respirar, desmayo, dolor pecho, sangrado fuerte, convulsiones, etc.
3. NO inventes síntomas.
4. NO ignores detalles proporcionados.

FORMATO:
Resumen:
- (texto)

Clasificación de riesgo: (BAJO / MODERADO / CRÍTICO)
"""
            },
            {"role": "user", "content": userMessages}
          ],
          "temperature": 0.3,
          "max_tokens": 300
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];

        setState(() {
          _messages.add({
            "role": "assistant",
            "sender": "AylluCare AI",
            "text": reply,
          });
        });
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "sender": "AylluCare AI",
            "text":
                "Hubo un problema al generar el resumen. Código: ${response.statusCode}",
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "sender": "AylluCare AI",
          "text": "Error de conexión al generar resumen.",
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        title: const Text('Ayllu AI'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.darkBlue.withOpacity(0.8)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(color: AppColors.lightBlue),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Describe tus síntomas...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.lightBlue),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _finishEvaluation,
                  child: const Text(
                    "Finalizar evaluación",
                    style: TextStyle(color: AppColors.lightBlue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
