import 'package:flutter/material.dart';
import 'package:plantiq/models/programacion_riego.dart';
import '../../services/api_service.dart';
import '../../models/cultivo.dart';

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
    futureCultivos = ApiService.getCultivos();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureCultivos = ApiService.getCultivos();
    });
  }

  void _createRiego(Cultivo cultivo) {
    final TextEditingController duracionController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Nuevo riego en ${cultivo.nombreCultivo}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                      });
                    }
                  },
                  child: Text(
                    selectedTime == null
                        ? "Selecciona hora de inicio"
                        : "Hora inicio: ${selectedTime!.format(context)}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: duracionController,
                  decoration: const InputDecoration(
                    labelText: "Duración (minutos)",
                    prefixIcon: Icon(Icons.timer),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Seleccione la hora de inicio'),
                      ),
                    );
                    return;
                  }

                  final duracion = int.tryParse(duracionController.text) ?? 0;
                  if (duracion <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingrese duración válida')),
                    );
                    return;
                  }

                  // Convertir TimeOfDay a formato 24 horas HH:mm:ss para backend
                  final ahora = DateTime.now();
                  final dt = DateTime(
                    ahora.year,
                    ahora.month,
                    ahora.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  final horaFormateada =
                      "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:00";

                  bool success = await ApiService.createRiego(
                    cultivo.id,
                    horaFormateada, // enviar en formato HH:mm:ss
                    duracion,
                  );

                  if (success) {
                    Navigator.pop(context);
                    _refreshData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al guardar el riego'),
                      ),
                    );
                  }
                },
                child: const Text("Guardar"),
              ),
            ],
          ),
        );
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Nuevo riego en ${cultivo.nombreCultivo}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Inicio de riego",
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Duración (minutos)",
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _editRiegoMenu(ProgramacionRiego programacion) {
    // Controladores para los campos, inicializados con los valores actuales
    final TextEditingController inicioController = TextEditingController(
      text: programacion.activo.toString().split(" ")[0],
    );
    final TextEditingController duracionController = TextEditingController(
      text: programacion.duracion.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Editar riego: ${programacion.activo}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: inicioController,
                decoration: const InputDecoration(
                  labelText: "Inicio de riego",
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: duracionController,
                decoration: const InputDecoration(
                  labelText: "Duración (minutos)",
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí luego metes tu lógica para actualizar el riego
                print("Nuevo inicio: ${inicioController.text}");
                print("Nueva duración: ${duracionController.text}");
                Navigator.pop(context);
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        );
      },
    );
  }

  void _deleteRiego(ProgramacionRiego programacion) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar riego "${programacion.activo}"?'),
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
      bool success = await ApiService.eliminarRiego(
        programacion.id,
      ); // Asegúrese que `programacion` tenga `id`
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riego eliminado exitosamente')),
        );
        _refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el riego')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Listado de Riegos por cultivo',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Cultivo>>(
                  future: futureCultivos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colors.tertiary,
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
                      return Center(
                        child: Text(
                          'No hay cultivos disponibles',
                          style: TextStyle(color: colors.tertiary),
                        ),
                      );
                    }
                    final cultivos = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      color: colors.tertiary,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: cultivos.length,
                        itemBuilder: (context, index) {
                          final cultivo = cultivos[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.surface,
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
                                      cultivo.nombreCultivo ?? 'Sin nombre',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: colors.tertiary,
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
                                if (cultivo.programaciones.isNotEmpty)
                                  ...cultivo.programaciones.map((
                                    ProgramacionRiego,
                                  ) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          "Riego a las ${ProgramacionRiego.inicio ?? 'N/A'}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        subtitle: Text(
                                          'Duración: ${ProgramacionRiego.duracion?.toString() ?? 'N/A'} minutos',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                        trailing: Wrap(
                                          spacing: 8,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: colors.surface,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: colors.tertiary,
                                                ),
                                                tooltip: 'Editar',
                                                onPressed: () => _editRiegoMenu(
                                                  ProgramacionRiego,
                                                ),
                                                splashRadius: 20,
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                tooltip: 'Eliminar',
                                                onPressed: () => _deleteRiego(
                                                  ProgramacionRiego,
                                                ),
                                                splashRadius: 20,
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                else
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'No hay riegos programados',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
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
      ),
    );
  }
}
