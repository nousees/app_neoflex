import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _firstName = '';
  String _lastName = '';
  bool _isLoading = false;
  String? _error;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _email,
        password: _password,
      );
      if (response.user != null) {
        // Создаём профиль в таблице profiles
        await Supabase.instance.client.from('profiles').insert({
          'id': response.user!.id,
          'first_name': _firstName,
          'last_name': _lastName,
        });
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = 'Ошибка регистрации. Попробуйте другой email.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка регистрации: \n'+e.toString();
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
                        Text('Регистрация', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6200EA))),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Имя'),
                          validator: (value) => value != null && value.isNotEmpty ? null : 'Введите имя',
                          onChanged: (v) => _firstName = v,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Фамилия'),
                          validator: (value) => value != null && value.isNotEmpty ? null : 'Введите фамилию',
                          onChanged: (v) => _lastName = v,
                        ),
                        SizedBox(height: 12),
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
                        SizedBox(height: 12),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Подтвердите пароль'),
                          obscureText: true,
                          validator: (value) => value == _password ? null : 'Пароли не совпадают',
                          onChanged: (v) => _confirmPassword = v,
                        ),
                        if (_error != null) ...[
                          SizedBox(height: 12),
                          Text(_error!, style: TextStyle(color: Colors.red)),
                        ],
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Зарегистрироваться'),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: Text('Уже есть аккаунт? Войти'),
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