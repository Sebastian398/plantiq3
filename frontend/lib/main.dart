import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'package:plantiq/theme.dart';
import 'package:plantiq/widgets/theme_logo.dart';
import 'package:plantiq/widgets/theme_provider.dart';

// Widget para botón con hover simple (opacidad)
class SimpleHoverButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const SimpleHoverButton({super.key, required this.onTap, required this.child});

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
          opacity: _isHovered ? 0.7 : 1.0, // un poco menos opaco en hover
          child: widget.child,
        ),
      ),
    );
  }
}

// Widget para enlace simple con hover (opacidad)
class SimpleHoverLink extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const SimpleHoverLink({super.key, required this.onTap, required this.child});

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

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Página de Inicio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: themeProvider.themeMode,
      home: const PaginaInicio(),
    );
  }
}

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface, // fondo dinámico
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface, // superficie dinámica
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 400,
                width: 700,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ThemedLogo(width: 400,),
                    const SizedBox(height: 32),
                    Text(
                      '"Agua precisa, tierra productiva."',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface, // texto dinámico
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tus cultivos siempre saludables con nuestro sistema de riego inteligente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.onSurface, // texto dinámico
                      ),
                    ),
                    const SizedBox(height: 40),
                    SimpleHoverButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [colors.primary, colors.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Comenzar',
                          style: TextStyle(
                            color: colors.onPrimary, // texto sobre el gradiente
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(text: 'Si no te has inscrito registrate '),
                          WidgetSpan(
                            child: SimpleHoverLink(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                                );
                              },
                              child: Text(
                                'aquí.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary, // usa el color principal
                                ),
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
