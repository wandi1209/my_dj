import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TentangAplikasiPage extends StatefulWidget {
  const TentangAplikasiPage({super.key, required this.title});

  final String title;

  @override
  State<TentangAplikasiPage> createState() {
    return _TentangAplikasiPageState();
  }
}

class _TentangAplikasiPageState extends State<TentangAplikasiPage> {
  final Uri _url = Uri.parse('https://wandidev.my.id');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: MyDJ"),
            const Text("Tagline: Aplikasi jurnal harian guru"),
            Text("Version: 1.0.0+1"),
            Text("Dibuat oleh: Wandi"),
            ElevatedButton(
              onPressed: _launchUrl,
              child: const Text("Pembuat: https://wandidev.my.id"),
            ),
          ],
        ),
      ),
    );
  }
}
