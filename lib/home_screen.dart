import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ayllucare_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ayllucare_app/core/app_constants.dart';
import 'features/appointment/appointments_screen.dart';
import 'features/prescription/prescription_history_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/anamnesis/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const _HomeContent(),
      const AppointmentsScreen(),
      const PrescriptionHistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.lightBlue,
        unselectedItemColor: AppColors.textBlue,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  String userName = "Usuario";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getInt("userId");
    if (token == null || userId == null) return;

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}/users/$userId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userName = "${data["firstName"]} ${data["lastName"]}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bienvenido/a de vuelta,',
                  style: const TextStyle(fontSize: 18, color: AppColors.textBlue)),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.medical_services),
                label: const Text('Solicitar asistencia médica (Ayllu AI)'),
              ),

              const SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: const Text('Próxima cita: Cardiología'),
                  subtitle: const Text('10 Oct, 09:30 AM'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final homeState =
                        context.findAncestorStateOfType<_HomeScreenState>();
                    homeState?.setState(() => homeState._currentIndex = 1);
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text('Métricas de salud (Último registro)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: const [
                            Text('Presión arterial'),
                            Text('120/80',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('mmHg (normal)'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: const [
                            Text('IMC'),
                            Text('24.5',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('Normal'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text('Noticias de salud',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: Icon(Icons.article_outlined, color: AppColors.lightBlue),
                  title: const Text('5 Consejos para dormir mejor'),
                  subtitle: const Text(
                      'El descanso es clave para la salud mental y física'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
