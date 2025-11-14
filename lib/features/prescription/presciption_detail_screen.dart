import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Receta | 15/09/2025'),
        backgroundColor: AppColors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Receta para migraña crónica',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightBlue, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contenido de la indicación',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ingredientes:\n'
                    '- Ibuprofeno (400mg) - 1 tableta\n'
                    '- Paracetamol (500mg) - 1 tableta\n\n'
                    'Instrucciones:\n'
                    'Tomar una tableta de cada uno con la comida principal.\n'
                    'Repetir si el dolor persiste después de 6 horas.\n'
                    'No exceder 3 dosis diarias.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
