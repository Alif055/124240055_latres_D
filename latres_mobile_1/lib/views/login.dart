import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../nav.dart';


const String kNim = '124240055';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();

  Future<void> _login() async {
    final user = _userC.text.trim();
    if (user.isEmpty) return _msg('Username tidak boleh kosong');
    if (_passC.text != kNim) return _msg('Password salah');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user);
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainPage(username: user)));
  }

  void _msg(String s) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Icon(Icons.storefront, size: 80, color: Colors.indigo),
            const Text('Toko Online',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _userC,
              decoration: const InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passC,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password (NIM)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _login, child: const Text('Login')),
            ),
          ]),
        ),
      ),
    );
  }
}
