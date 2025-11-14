import 'package:flutter/material.dart';
import 'package:ayllucare_app/theme/colors.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Neurología | 2025-10-10'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Neurología (URGENTE)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Dr. Ricardo Pérez\n10/10/2025 - 09:30 AM\nClínica Central de Urgencias\nPresencial'),
              ),
            ),
            const SizedBox(height: 15),
            const Text('Motivo', style: TextStyle(fontWeight: FontWeight.bold)),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Emergencia neurológica: Revisión de síntomas brindada por Ayllu AI'),
              ),
            ),
            const SizedBox(height: 15),
            const Text('Instrucciones del doctor', style: TextStyle(fontWeight: FontWeight.bold)),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Diríjase inmediatamente al establecimiento. No se automedique. Le esperamos en Triage de Emergencia.'),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                  child: const Text('Ver ubicación'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepBlue),
                  child: const Text('Llamar'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Cancelar cita', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}