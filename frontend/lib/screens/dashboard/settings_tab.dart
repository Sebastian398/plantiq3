import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:plantiq/screens/auth/mail_reset.dart';
import 'package:plantiq/widgets/theme_provider.dart';
import 'package:plantiq/main.dart';

// Ejemplo: Funciones para manejar token local (ajusta según tu implementación)
Future<String?> getStoredToken() async {
  // Implementa obtener token localmente (SharedPreferences, Provider, etc.)
  // Ejemplo: final prefs = await SharedPreferences.getInstance(); return prefs.getString('token');
  return 'tu_token_de_ejemplo'; // Remplaza con tu lógica real
}

Future<void> clearStoredToken() async {
  // Implementa limpiar el token guardado localmente
  // Ejemplo: final prefs = await SharedPreferences.getInstance(); await prefs.remove('token');
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool modoClaro = false;

  Future<void> logout() async {
    final token = await getStoredToken();
    if (token == null) return; // No hay token guardado

    final response = await http.post(
      Uri.parse('https://tu-api/logout/'), // Cambia por URL real de tu backend
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      await clearStoredToken();
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacementNamed('/login'); // Ruta a pantalla login
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Ajustes",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: Icon(Icons.light_mode, color: colors.tertiary),
            title: Text(
              'Modo claro',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.light,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          Divider(color: colors.tertiary),
          ListTile(
            leading: Icon(Icons.person, color: colors.tertiary),
            title: Text(
              'Datos del Usuario',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditarDatosUsuario(),
                ),
              );
            },
          ),
          Divider(color: colors.tertiary),
          ListTile(
            leading: Icon(Icons.agriculture, color: colors.tertiary),
            title: Text(
              'Datos de la Finca',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditarDatosFinca(),
                ),
              );
            },
          ),
          Divider(color: colors.tertiary),
          ListTile(
            leading: Icon(Icons.lock, color: colors.tertiary),
            title: Text(
              'Autenticación',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: colors.surface,
                  title: Text(
                    'Opciones de Autenticación',
                    style: TextStyle(color: colors.tertiary),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            colors.surface,
                          ),
                          fixedSize: WidgetStateProperty.all(
                            const Size(200, 30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MailResetScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Cambiar Contraseña',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            colors.surface,
                          ),
                          fixedSize: WidgetStateProperty.all(
                            const Size(200, 30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaginaInicio(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Color.fromARGB(255, 191, 37, 37),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditarDatosUsuario extends StatefulWidget {
  const EditarDatosUsuario({super.key});

  @override
  State<EditarDatosUsuario> createState() => _EditarDatosUsuarioState();
}

class _EditarDatosUsuarioState extends State<EditarDatosUsuario> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombresController = TextEditingController(
    text: "Daniel Samir",
  );
  final TextEditingController apellidosController = TextEditingController(
    text: "Gonzáles Pérez",
  );
  final TextEditingController telefonoController = TextEditingController(
    text: "0180004455",
  );
  final TextEditingController correoController = TextEditingController(
    text: "GonzalesPerezSamir@gmail.com",
  );
  final TextEditingController rolController = TextEditingController(
    text: "Administrador",
  );
  final TextEditingController direccionController = TextEditingController(
    text: "Calle 22 sur # 56-27 n",
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.tertiary),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '',
        ),
        title: Text(
          'Editar Datos del usuario',
          style: TextStyle(color: colors.tertiary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nombresController, 'Nombres', icon: Icons.person),
              const SizedBox(height: 12),
              _buildTextField(
                apellidosController,
                'Apellidos',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                telefonoController,
                'Teléfono de contacto',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                correoController,
                'Correo Electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(rolController, 'Rol', icon: Icons.badge),
              const SizedBox(height: 12),
              _buildTextField(
                direccionController,
                'Dirección',
                icon: Icons.home,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Datos guardados correctamente',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        backgroundColor: colors.surface,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                child: Text(
                  'Guardar',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isEmail = false,
  }) {
    final colors = Theme.of(context).colorScheme;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: isHovered
                  ? colors.surface.withOpacity(0.9)
                  : colors.surface,
              prefixIcon: icon != null ? Icon(icon) : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.tertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.tertiary, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa ${label.toLowerCase()}';
              }
              if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Por favor ingresa un correo válido';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}

class EditarDatosFinca extends StatefulWidget {
  const EditarDatosFinca({super.key});

  @override
  State<EditarDatosFinca> createState() => _EditarDatosFincaState();
}

class _EditarDatosFincaState extends State<EditarDatosFinca> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreFincaController = TextEditingController(
    text: "Finca Napolitana",
  );
  final TextEditingController tipoCultivoController = TextEditingController(
    text: "Granos, tubérculos y frutas",
  );
  final TextEditingController tamanoAreaController = TextEditingController();
  final TextEditingController zonasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '',
        ),
        title: Text(
          'Editar Datos de la Finca',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                nombreFincaController,
                'Nombre de la finca o predio',
                icon: Icons.landscape,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                tipoCultivoController,
                'Tipo de cultivo(s) registrados',
                icon: Icons.eco,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                tamanoAreaController,
                'Tamaño del área cubierta por aspersores (m² o ha)',
                icon: Icons.crop_square,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                zonasController,
                'Zonas configuradas',
                icon: Icons.map,
                hintText: 'Ej. Lote 1, Lote 2...',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Datos de la finca guardados',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        backgroundColor: colors.surface,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                child: Text(
                  'Guardar',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    String? hintText,
  }) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      style: TextStyle(color: colors.tertiary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: colors.surface,
        prefixIcon: icon != null ? Icon(icon) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.tertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.tertiary),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa $label'.toLowerCase();
        }
        return null;
      },
    );
  }
}
