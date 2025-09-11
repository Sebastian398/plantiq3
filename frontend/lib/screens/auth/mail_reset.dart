import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para jsonEncode

import 'register_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../auth/login_screen.dart';
import 'package:plantiq/widgets/theme_logo.dart';
import 'package:plantiq/main.dart';

class SimpleHoverButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const SimpleHoverButton({
    required this.onTap,
    required this.child,
    super.key,
  });
  @override
  _SimpleHoverButtonState createState() => _SimpleHoverButtonState();
}

class _SimpleHoverButtonState extends State<SimpleHoverButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _isHovered ? 0.7 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}

class SimpleHoverLink extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const SimpleHoverLink({required this.onTap, required this.child, super.key});
  @override
  _SimpleHoverLinkState createState() => _SimpleHoverLinkState();
}

class _SimpleHoverLinkState extends State<SimpleHoverLink> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _isHovered ? 0.7 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}

class MailResetScreen extends StatefulWidget {
  const MailResetScreen({super.key});
  @override
  State<MailResetScreen> createState() => _MailResetScreen();
}

class _MailResetScreen extends State<MailResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  Future<bool> sendResetEmail(String email) async {
    final url = Uri.parse('http://localhost:8000/api/password_reset/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        // Opcional: parsear respuesta si backend envía confirmación
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool success = await sendResetEmail(_emailController.text.trim());
      setState(() {
        _isLoading = false;
      });
      if (success) {
        // Navegar a Dashboard solo si éxito
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // Mostrar error al usuario
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error enviando correo, intenta de nuevo'),
          ),
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 600,
                height: 600,
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaginaInicio(),
                          ),
                        );
                      },
                      child: ThemedLogo(width: 400),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Restablecer contraseña',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: colors.tertiary),
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo';
                              }
                              if (!value.contains('@')) {
                                return 'Correo inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : SimpleHoverButton(
                                    onTap: _submitForm,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            colors.primary,
                                            colors.secondary,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Enviar Correo',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  const TextSpan(
                                    text: 'Si no te has inscrito regístrate ',
                                  ),
                                  WidgetSpan(
                                    child: SimpleHoverLink(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'aquí.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  const TextSpan(text: 'Inicio de sesión '),
                                  WidgetSpan(
                                    child: SimpleHoverLink(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'aquí.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
