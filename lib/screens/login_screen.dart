import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _error;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _email,
        password: _password,
      );
      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = 'Ошибка входа. Проверьте email и пароль.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка входа: ' + e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFFFF6200)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/logo.png', width: 80, height: 80),
                        SizedBox(height: 16),
                        Text('Вход', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6200EA))),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value != null && value.contains('@') ? null : 'Введите корректный email',
                          onChanged: (v) => _email = v,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Пароль'),
                          obscureText: true,
                          validator: (value) => value != null && value.length >= 6 ? null : 'Минимум 6 символов',
                          onChanged: (v) => _password = v,
                        ),
                        if (_error != null) ...[
                          SizedBox(height: 12),
                          Text(_error!, style: TextStyle(color: Colors.red)),
                        ],
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Войти'),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                          child: Text('Нет аккаунта? Зарегистрироваться'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 