import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ayllucare_app/theme/colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  DateTime? _selectedDate;

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime hoy = DateTime.now();
    final DateTime fechaMaxima = DateTime(hoy.year - 18, hoy.month, hoy.day); // mínimo 18 años

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaMaxima,
      firstDate: DateTime(1900),
      lastDate: fechaMaxima,
      helpText: 'Selecciona tu fecha de nacimiento',
      locale: const Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        _ageController.text = _calculateAge(picked).toString();
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _registrarUsuario() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada correctamente')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.health_and_safety, size: 60, color: AppColors.lightBlue),
                    SizedBox(height: 10),
                    Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Completa tus datos para registrarte en AylluCare',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              //nombre completo
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Nombre completo', Icons.person),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Por favor ingresa tu nombre' : null,
              ),
              const SizedBox(height: 20),

              //DNI
              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('DNI', Icons.badge),
                maxLength: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu DNI';
                  } else if (value.length != 8) {
                    return 'El DNI debe tener 8 dígitos';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'El DNI solo puede contener números';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              //fecha de nacimiento
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                decoration: _inputDecoration('Fecha de nacimiento', Icons.calendar_today)
                    .copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.date_range, color: AppColors.lightBlue),
                    onPressed: () => _selectBirthDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona tu fecha de nacimiento';
                  }
                  if (_selectedDate != null && _calculateAge(_selectedDate!) < 18) {
                    return 'Debes tener al menos 18 años';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //edad calculada automáticamente
              TextFormField(
                controller: _ageController,
                readOnly: true,
                decoration: _inputDecoration('Edad', Icons.cake),
              ),
              const SizedBox(height: 20),

              //correo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Correo electrónico', Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Correo no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //contra
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration('Contraseña', Icons.lock).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  } else if (value.length < 6) {
                    return 'Debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: _inputDecoration('Confirmar contraseña', Icons.lock_outline)
                    .copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(
                        () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirma tu contraseña';
                  } else if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _registrarUsuario,
                  child: const Text(
                    'Registrarme',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes una cuenta? ',
                      style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Inicia sesión',
                      style: TextStyle(
                        color: AppColors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.lightBlue),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
