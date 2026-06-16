import 'package:flutter/material.dart';
import 'package:sistema_actividades/models/registro_model.dart';
import 'package:sistema_actividades/services/api_service.dart';

class DashboardPage extends StatelessWidget {
  // Retiramos la lista estática del constructor porque ahora los datos vienen de NestJS
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Paleta de colores pastel para los Cards de visualización
    final List<Color> colores = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.teal.shade100
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Registros'),
        backgroundColor: Colors.indigo.shade50,
      ),
      // El FutureBuilder se encarga de escuchar al backend en tiempo real
      body: FutureBuilder<List<Registro>>(
        future: ApiService().obtenerRegistros(), // Consumo del método GET
        builder: (context, snapshot) {
          // 1. Mientras espera la respuesta de NestJS:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Si ocurre un error de red o CORS:
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Error al cargar datos del backend desde NestJS'),
            );
          }

          // Atrapamos la lista real de la base de datos MySQL
          final listaDeRegistros = snapshot.data!;

          // 3. Si la base de datos está vacía:
          if (listaDeRegistros.isEmpty) {
            return const Center(
              child: Text('No hay registros guardados en MySQL todavía.'),
            );
          }

          // 4. Si todo está perfecto, renderizamos tu GridView Pastel con los datos de la DB:
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,       // Ancho máximo de cada Card
                mainAxisSpacing: 12,          // Espaciado vertical
                crossAxisSpacing: 12,         // Espaciado horizontal
                childAspectRatio: 1.2,        // Relación de aspecto
              ),
              itemCount: listaDeRegistros.length,
              itemBuilder: (context, index) {
                final reg = listaDeRegistros[index];
                // Asignación secuencial de colores usando el residuo
                final colorCard = colores[index % colores.length];

                return Card(
                  color: colorCard,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reg.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(color: Colors.black26),
                        Expanded(
                          child: Text(
                            reg.descripcion,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Resp: ${reg.responsable}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Fecha: ${reg.fecha}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}