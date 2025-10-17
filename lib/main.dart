import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/register_point_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SA - Registro de Ponto',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // Use named routes for navigation
      initialRoute: '/login',
      routes: {
        '/': (context) => const LoginView(),
        '/login': (context) => const LoginView(),
        '/cadastro': (context) => const CadastroView(),
        '/register_point': (context) => const RegisterPointView(),
      },
    );
  }
}
