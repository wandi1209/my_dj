import 'package:flutter/material.dart';
import 'package:MyDJ/data/data_provider.dart';
import 'package:MyDJ/data/jurnal.dart';
import 'package:MyDJ/pages/buat_jurnal_page.dart';
import 'package:provider/provider.dart';

class DetailJurnalPage extends StatelessWidget {
  final Jurnal jurnal;

  const DetailJurnalPage({super.key, required this.jurnal});

  Widget _buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentJurnal = context
        .watch<DataProvider>()
        .jurnalTersimpan
        .firstWhere((j) => j.id == jurnal.id, orElse: () => jurnal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jurnal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Kelas', currentJurnal.kelas),
              _buildField('Mata Pelajaran', currentJurnal.mapel),
              _buildField('Jam Ke-', currentJurnal.jam.toString()),
              _buildField(
                'Tujuan Pembelajaran',
                currentJurnal.tujuanPembelajaran,
              ),
              _buildField(
                'Materi / Topik Pembelajaran',
                currentJurnal.materiTopikPembelajaran,
              ),
              _buildField(
                'Kegiatan Pembelajaran',
                currentJurnal.kegiatanPembelajaran,
              ),
              _buildField(
                'Dimensi Profil Pelajar Pancasila',
                currentJurnal.dimensiProfilPelajarPancasila,
              ),
              _buildField('Waktu Dibuat', currentJurnal.createdAt.toString()),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BuatJurnalPage(jurnal: currentJurnal),
                      ),
                    );
                  },
                  child: const Text('Edit Jurnal Ini'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
