import 'package:flutter/material.dart';
import 'package:ayllucare_app/theme/colors.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mis citas, 1 pendiente(s)'),
        backgroundColor: AppColors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aquí verás todas tus citas programadas'),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: const Text('Neurología con Dr. Ricardo Pérez'),
                subtitle: const Text('10/10/2025 a las 09:30 AM\nPresencial'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AppointmentDetailScreen()),
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
