import 'package:flutter/material.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';

/// Placeholder for DiagnosticExam (role-detection quiz)
class DiagnosticExamScreen extends StatefulWidget {
  final void Function(String role) onComplete;

  const DiagnosticExamScreen({super.key, required this.onComplete});

  @override
  State<DiagnosticExamScreen> createState() => _DiagnosticExamScreenState();
}

class _DiagnosticExamScreenState extends State<DiagnosticExamScreen> {
  int _currentQ = 0;
  final Map<String, int> _scores = {
    'primary': 0,
    'secondary': 0,
    'preparatory': 0,
    'university': 0,
  };

  static const _questions = [
    {
      'q': '¿Qué es un circuito eléctrico?',
      'options': [
        {'text': 'No sé qué es eso 🤷', 'role': 'primary'},
        {'text': 'Un camino cerrado por donde fluye electricidad', 'role': 'secondary'},
        {'text': 'Red de componentes con fuente, conductores y carga', 'role': 'preparatory'},
        {'text': 'Sistema modelable con Leyes de Kirchhoff', 'role': 'university'},
      ],
    },
    {
      'q': '¿Qué es un sensor?',
      'options': [
        {'text': 'Algo que detecta cosas 🔍', 'role': 'primary'},
        {'text': 'Dispositivo que mide cambios en el entorno', 'role': 'secondary'},
        {'text': 'Transductor que convierte magnitudes físicas en señales eléctricas', 'role': 'preparatory'},
        {'text': 'Elemento con función de transferencia definida y rango de operación', 'role': 'university'},
      ],
    },
    {
      'q': '¿Qué es programar?',
      'options': [
        {'text': 'Dar instrucciones a una computadora 💻', 'role': 'primary'},
        {'text': 'Escribir código para que una máquina haga tareas', 'role': 'secondary'},
        {'text': 'Diseñar algoritmos y estructuras de datos', 'role': 'preparatory'},
        {'text': 'Implementar soluciones con paradigmas y patrones de diseño', 'role': 'university'},
      ],
    },
    {
      'q': '¿Qué es la Ley de Ohm?',
      'options': [
        {'text': 'No la conozco 🤔', 'role': 'primary'},
        {'text': 'V = I × R (voltaje, corriente, resistencia)', 'role': 'secondary'},
        {'text': 'Relación lineal entre tensión e intensidad en conductores óhmicos', 'role': 'preparatory'},
        {'text': 'Modelo macroscópico de conducción eléctrica, limitado a materiales lineales', 'role': 'university'},
      ],
    },
    {
      'q': '¿Qué sabes de Arduino?',
      'options': [
        {'text': '¿Qué es eso? 🤖', 'role': 'primary'},
        {'text': 'Placa para aprender electrónica y robótica', 'role': 'secondary'},
        {'text': 'Microcontrolador ATmega con entorno de desarrollo propio', 'role': 'preparatory'},
        {'text': 'Plataforma AVR con bootloader, registros y programación bare-metal', 'role': 'university'},
      ],
    },
  ];

  void _answer(String role) {
    _scores[role] = (_scores[role] ?? 0) + 1;

    if (_currentQ + 1 >= _questions.length) {
      // Determine role from highest score
      String bestRole = 'secondary';
      int bestScore = 0;
      _scores.forEach((r, s) {
        if (s > bestScore) {
          bestScore = s;
          bestRole = r;
        }
      });
      widget.onComplete(bestRole);
    } else {
      setState(() => _currentQ++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQ];

    return Scaffold(
      body: Container(
        color: AppTheme.bgPrimary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  children: [
                    const Text('🧪', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    const Text('Examen Diagnóstico',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                    const Spacer(),
                    Text('${_currentQ + 1}/${_questions.length}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentQ + 1) / _questions.length,
                    minHeight: 6,
                    backgroundColor: AppTheme.bgSecondary,
                    valueColor: const AlwaysStoppedAnimation(AppTheme.accentPurple),
                  ),
                ),
                const SizedBox(height: 30),
                // Question
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.borderColor),
                    boxShadow: AppTheme.shadowSm,
                  ),
                  child: Text(
                    q['q'] as String,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),
                // Options
                Expanded(
                  child: ListView(
                    children: (q['options'] as List).map<Widget>((opt) {
                      final option = opt as Map<String, String>;
                      return GestureDetector(
                        onTap: () => _answer(option['role']!),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.bgSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Text(
                            option['text']!,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, height: 1.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

