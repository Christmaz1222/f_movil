import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  // Variable para almacenar la foto capturada en la memoria del teléfono
  File? _imagenSeleccionada;
  final ImagePicker _picker = ImagePicker();

  // Método asíncrono para interactuar con la cámara nativa
  Future<void> _tomarFoto() async {
    try {
      // Abre la cámara y espera a que el usuario presione el obturador
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Optimización de peso para el futuro envío a NestJS
      );

      if (foto != null) {
        setState(() {
          _imagenSeleccionada = File(foto.path); // Convertimos la ruta a un File de Dart
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Fotografía capturada con éxito!')),
        );
      }
    } catch (e) {
      print("Error al abrir la cámara: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactuar con la Cámara'),
        backgroundColor: Colors.indigo.shade50,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contenedor dinámico: Muestra la foto o un marcador de posición
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.indigo.shade100, width: 2),
                ),
                child: _imagenSeleccionada != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.file(
                    _imagenSeleccionada!,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Ninguna captura realizada',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Botón de acción para activar el hardware
              ElevatedButton.icon(
                onPressed: _tomarFoto,
                icon: const Icon(Icons.photo_camera),
                label: const Text('Disparar Cámara'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}