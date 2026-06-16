import 'package:flutter/material.dart';
import 'package:sistema_actividades/models/registro_model.dart';
import 'package:sistema_actividades/pages/dashboard_page.dart';
import 'package:sistema_actividades/pages/registro_page.dart';
// 1. SOLUCIÓN: Importamos la página del PDF (Ajusta la ruta exacta de tu carpeta si es necesario)
import 'package:sistema_actividades/pages/pdf_page.dart';
import 'package:sistema_actividades/pages/about_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Registros',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Estado global unificado usando el modelo oficial de la base de datos
  final List<Registro> _listaRegistros = [];

  @override
  Widget build(BuildContext context) {
    // Lista de las 3 páginas conectadas de forma limpia
    final List<Widget> paginas = [
      const DashboardPage(), // Añadimos const ya que no recibe parámetros estáticos
      RegistroPage(
        registros: _listaRegistros,
        onRegistroGuardado: () => setState(() {}),
      ),
      PdfPage(registros: _listaRegistros), // Ahora recibirá el tipo correcto una vez arreglado su import
      const AboutPage(),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.edit_note_outlined),
                selectedIcon: Icon(Icons.edit_note),
                label: Text('Registro'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.picture_as_pdf_outlined),
                selectedIcon: Icon(Icons.picture_as_pdf),
                label: Text('PDF Reporte'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info_outline),
                selectedIcon: Icon(Icons.info),
                label: Text('Acerca de'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),

          Expanded(
            child: paginas[_selectedIndex],
          ),
        ],
      ),
    );
  }
}