import 'package:flutter/material.dart';
import 'package:MyDJ/components/password_field.dart';
import 'package:MyDJ/data/data_provider.dart';
import 'package:MyDJ/pages/simple_home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final String title = 'MyDJ - Welcome';

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String namaPengguna = '';
  String sandi = '';

  Future<void> _login(BuildContext context) async {
    DataProvider provider = context.read<DataProvider>();

    if (namaPengguna == 'guru' && sandi == 'guru') {
      await provider.saveLoginInfo(namaPengguna, sandi);

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SimpleHomePage(title: 'Beranda'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/login_icon.png', width: 250),
                const Text(
                  'Log-In',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Nama Pengguna:'),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => {
                    setState(() {
                      namaPengguna = value;
                    }),
                  },
                ),
                const SizedBox(height: 10),
                const Text('Sandi:'),
                const SizedBox(height: 10),
                PasswordField(
                  onChanged: (value) => {
                    setState(() {
                      sandi = value;
                    }),
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => {_login(context)},
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
