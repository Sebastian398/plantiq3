import 'package:flutter/material.dart';
import '../../models/cultivo.dart';
import '../../models/riegos.dart';
import '../../services/api_service.dart';

class RisksListScreen extends StatefulWidget {
  const RisksListScreen({super.key});

  @override
  _RisksListScreenState createState() => _RisksListScreenState();
}

class _RisksListScreenState extends State<RisksListScreen> {
  late Future<List<Cultivo>> futureCultivos;

  @override
  void initState() {
    super.initState();
    futureCultivos = ApiService.getCultivos(); // Cambiado a Cultivos
  }

  Future<void> _refreshData() async {
    setState(() {
      futureCultivos = ApiService.getCultivos();
    });
  }

  void _createRiego(Cultivo cultivo) {
    print('Crear riego para cultivo: ${cultivo.nombreCultivo}');
  }

  void _editRiego(Riego riego) {
    print('Editar riego id: ${riego.id}');
  }

  void _deleteRiego(Riego riego) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar riego "${riego.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      print('Eliminar riego id: ${riego.id}');
      await ApiService.eliminarProgramacionRiego(riego.id);
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1F2A),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Listado de Riegos por Cultivo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE3E3E3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Cultivo>>(
                  future: futureCultivos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFDA00FF),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay cultivos disponibles',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      );
                    }
                    final cultivos = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      color: const Color(0xFFDA00FF),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: cultivos.length,
                        itemBuilder: (context, index) {
                          final cultivo = cultivos[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2B2F3A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cultivo.nombreCultivo,
                                      style: const TextStyle(
                                        color: Color(0xFFE3E3E3),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1C1F2A),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        tooltip: 'Nuevo riego',
                                        onPressed: () => _createRiego(cultivo),
                                        splashRadius: 20,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Aquí se debe agregar la lista de riegos asociados al cultivo si existe
                                // Pero en tu modelo Cultivo no hay relación directa con Riego,
                                // entonces depende de que la API devuelva esa info o se adapte la estructura.
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'No hay riegos programados',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    ),);
}
}