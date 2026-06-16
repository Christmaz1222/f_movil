import 'package:flutter/material.dart';
import 'package:sistema_actividades/models/registro_model.dart';
import 'package:sistema_actividades/services/api_service.dart';

class RegistroPage extends StatefulWidget {
  final List<Registro> registros;
  final VoidCallback onRegistroGuardado;

  const RegistroPage({
    super.key,
    required this.registros,
    required this.onRegistroGuardado,
  });

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores oficiales definidos en tu archivo
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _fechaController = TextEditingController();
  final _respController = TextEditingController();

  @override
  void dispose() {
    // Buena práctica de Ingeniería: liberar memoria de los controladores
    _titleController.dispose();
    _descController.dispose();
    _fechaController.dispose();
    _respController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario de Registro')),
      body: Row(
        children: [
          // LADO IZQUIERDO: Formulario de captura con el botón asíncrono
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _fechaController,
                        decoration: const InputDecoration(labelText: 'Fecha (AAAA-MM-DD)', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _respController,
                        decoration: const InputDecoration(labelText: 'Responsable', border: OutlineInputBorder()),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 20),

                      // SOLUCIÓN AL BOTÓN CON ICONO Y CONTROLADORES CORREGIDOS:
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save), // Parámetro Icono Obligatorio
                        label: const Text('Guardar Registro'), // Parámetro Label Obligatorio
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {

                            final miApiService = ApiService();

                            // Corregimos los nombres de las variables al inglés oficial de tus controladores
                            final nuevo = Registro(
                              titulo: _titleController.text,
                              descripcion: _descController.text,
                              fecha: _fechaController.text,
                              responsable: _respController.text,
                            );

                            // Enviamos los datos por HTTP POST a NestJS
                            bool exito = await miApiService.crearRegistro(nuevo);

                            if (exito) {
                              // Añadimos localmente para actualizar la vista derecha
                              widget.registros.add(nuevo);
                              widget.onRegistroGuardado();

                              // Limpiamos cajas de texto
                              _titleController.clear();
                              _descController.clear();
                              _fechaController.clear();
                              _respController.clear();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('¡Guardado con éxito en MySQL a través de NestJS!')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al conectar con NestJS. Revisa el backend.')),
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),

          // LADO DERECHO: Visualización inmediata de la sesión actual
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.indigo.shade50,
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    'Registros en esta sesión (Vista Local)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
                Expanded(
                  child: widget.registros.isEmpty
                      ? const Center(child: Text('Ningún dato registrado aún.'))
                      : ListView.builder(
                    itemCount: widget.registros.length,
                    itemBuilder: (context, index) {
                      final item = widget.registros[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(item.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Resp: ${item.responsable} \nFecha: ${item.fecha}'),
                        isThreeLine: true,
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}