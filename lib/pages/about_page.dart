import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Sistema'),
        backgroundColor: Colors.indigo.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo o Icono Grande del Sistema
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo.shade100,
              child: const Icon(Icons.lock_clock, size: 60, color: Colors.indigo),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sistema de Actividades v1.0',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Proyecto Integrador - Ingeniería de Sistemas',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Card de Detalles Técnicos de la Arquitectura que armamos hoy
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ficha Técnica de la Integración',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _buildTechRow(Icons.phone_android, 'Frontend', 'Flutter & Dart (Desktop/Windows)'),
                    _buildTechRow(Icons.dns, 'Backend API', 'NestJS Rest Framework'),
                    _buildTechRow(Icons.storage, 'Base de Datos', 'MySQL con Prisma ORM 6'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sección de Créditos para los estudiantes
            const Text(
              'Desarrollado por:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.indigo.shade50,
              child: const ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Estudiantes del Laboratorio'),
                subtitle: Text('Grupo de Programación Móvil'),
                trailing: Text('2026', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para las filas de tecnología
  Widget _buildTechRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}