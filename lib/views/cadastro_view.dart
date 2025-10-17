// Tela de cadastro que registra novo usuário 
import 'package:flutter/material.dart';
import 'package:sa_app_registro_ponto/controllers/auth_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _passwordTemp = ''; // usado para comparar confirmação
  bool _loading = false;

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save(); // popula _email, _password
    setState(() => _loading = true);
    try {
      await AuthController.instance.register(
        email: _email.trim(),
        password: _password,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cadastro realizado')));
      Navigator.of(context).pop(); // volta ao login
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o e-mail';
                  final email = v.trim().toLowerCase();
                  final allowed = RegExp(r'^[^@]+@cargo\.connect\.com$');
                  if (!allowed.hasMatch(email)) return 'E-mail inválido';
                  return null;
                },
                onSaved: (v) => _email = v ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (v) => (v == null || v.length < 4)
                    ? 'Senha mínima 4 caracteres'
                    : null,
                onChanged: (v) => _passwordTemp = v, // guarda para comparação
                onSaved: (v) => _password = v ?? '',
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                obscureText: true,
                validator: (v) =>
                    v != _passwordTemp ? 'Senhas não conferem' : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doRegister,
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
