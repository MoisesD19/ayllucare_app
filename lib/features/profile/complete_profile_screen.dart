import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../theme/colors.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final contactNameCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final bloodTypeCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  // Campos dinámicos
  List<TextEditingController> chronicControllers = [];
  List<TextEditingController> medicationControllers = [];
  List<TextEditingController> allergyControllers = [];

  bool loading = false;

  // ---------------------------------------
  //  TEXT FIELD REUSABLE
  // ---------------------------------------
  Widget _textField(
    String label,
    TextEditingController ctrl, {
    bool number = false,
    bool optional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label + (optional ? " (opcional)" : ""),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) {
          if (optional) return null; // Si es opcional NO validar nada

          if (!number && (v == null || v.isEmpty)) {
            return "Campo obligatorio";
          }

          if (number && (v == null || double.tryParse(v) == null)) {
            return "Número inválido";
          }

          return null;
        },
      ),
    );
  }

  // ---------------------------------------
  //   CAMPOS DINÁMICOS
  // ---------------------------------------
  Widget _dynamicList(List<TextEditingController> list) {
    return Column(
      children: [
        for (int i = 0; i < list.length; i++)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: list[i],
                  decoration: const InputDecoration(
                    hintText: "Ingresar valor",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed:
                    list.length > 1 ? () => removeDynamicField(list, i) : null,
              )
            ],
          ),
        TextButton.icon(
          onPressed: () => addDynamicField(list),
          icon: const Icon(Icons.add),
          label: const Text("Agregar"),
        )
      ],
    );
  }

  void addDynamicField(List<TextEditingController> list) {
    setState(() {
      list.add(TextEditingController());
    });
  }

  void removeDynamicField(List<TextEditingController> list, int index) {
    setState(() {
      if (list.length > 1) {
        list.removeAt(index);
      }
    });
  }

  // ---------------------------------------
  //     SUBMIT PROFILE
  // ---------------------------------------
  Future<void> submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final url = Uri.parse("http://18.116.14.204:8080/api/v1/profiles");

    final body = {
      "firstName": firstNameCtrl.text,
      "lastName": lastNameCtrl.text,
      "dateOfBirth": dobCtrl.text,
      "emergencyContactName":
          contactNameCtrl.text.isEmpty ? null : contactNameCtrl.text,
      "emergencyContactPhone":
          contactPhoneCtrl.text.isEmpty ? null : contactPhoneCtrl.text,
      "gender": "MALE", // puedes cambiarlo luego
      "address": addressCtrl.text.isEmpty ? null : addressCtrl.text,
      "bloodType": bloodTypeCtrl.text,
      "heightCm": double.tryParse(heightCtrl.text),
      "weightKg": double.tryParse(weightCtrl.text),
      "chronicConditions": chronicControllers
          .map((c) => c.text)
          .where((e) => e.isNotEmpty)
          .toList(),
      "currentMedications": medicationControllers
          .map((c) => c.text)
          .where((e) => e.isNotEmpty)
          .toList(),
      "allergies":
          allergyControllers.map((c) => c.text).where((e) => e.isNotEmpty).toList(),
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    setState(() => loading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil completado correctamente")),
      );

      Navigator.pop(context, data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  }

  // ---------------------------------------
  //           INIT STATE
  // ---------------------------------------
  @override
  void initState() {
    chronicControllers.add(TextEditingController());
    medicationControllers.add(TextEditingController());
    allergyControllers.add(TextEditingController());
    super.initState();
  }

  // ---------------------------------------
  //          BUILD UI
  // ---------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Perfil'),
        backgroundColor: AppColors.lightBlue,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _textField("Nombre", firstNameCtrl),
                    _textField("Apellido", lastNameCtrl),
                    _textField("Fecha de nacimiento (YYYY-MM-DD)", dobCtrl),

                    _textField("Nombre de contacto de emergencia", contactNameCtrl,
                        optional: true),
                    _textField("Teléfono de emergencia", contactPhoneCtrl,
                        optional: true),

                    _textField("Dirección", addressCtrl, optional: true),

                    _textField("Tipo de sangre (O_POSITIVE, A_NEGATIVE...)", bloodTypeCtrl),
                    _textField("Altura (cm)", heightCtrl, number: true),
                    _textField("Peso (kg)", weightCtrl, number: true),

                    const SizedBox(height: 20),
                    const Text("Condiciones Crónicas",
                        style: TextStyle(fontSize: 17)),
                    const SizedBox(height: 10),
                    _dynamicList(chronicControllers),

                    const SizedBox(height: 20),
                    const Text("Medicamentos Actuales",
                        style: TextStyle(fontSize: 17)),
                    const SizedBox(height: 10),
                    _dynamicList(medicationControllers),

                    const SizedBox(height: 20),
                    const Text("Alergias", style: TextStyle(fontSize: 17)),
                    const SizedBox(height: 10),
                    _dynamicList(allergyControllers),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Guardar Perfil",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
