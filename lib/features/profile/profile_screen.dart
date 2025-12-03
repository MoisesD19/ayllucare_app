import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../iam/login_screen.dart';
import 'complete_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.lightBlue,
              child: Text(
                'C',
                style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Perfil del usuario',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textBlue),
            ),
            const SizedBox(height: 25),

            // BOTÓN: TERMINAR PERFIL
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
                  );
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Terminar perfil',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 25),

            // Cerrar sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.lightBlue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.lightBlue),
                label: const Text('Cerrar sesión', style: TextStyle(color: AppColors.lightBlue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
