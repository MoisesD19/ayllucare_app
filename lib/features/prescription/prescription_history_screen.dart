import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import 'presciption_detail_screen.dart';

class PrescriptionHistoryScreen extends StatelessWidget {
  const PrescriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Historial digital'),
        backgroundColor: AppColors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aquí verás todas tus consultas y recomendaciones',
              style: TextStyle(fontSize: 16, color: AppColors.textBlue),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: const Text('Receta para migraña crónica'),
                subtitle: const Text('Consulta del 15/09/2025'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryDetailScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
