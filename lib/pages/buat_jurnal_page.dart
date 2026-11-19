import 'package:flutter/material.dart';
import 'package:MyDJ/components/media_selector.dart';
import 'package:MyDJ/data/data_provider.dart';
import 'package:MyDJ/data/jurnal.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  final Jurnal? jurnal;

  const BuatJurnalPage({super.key, this.jurnal});

  String get title => jurnal != null ? 'Edit Jurnal' : 'Buat Jurnal';

  @override
  State<StatefulWidget> createState() {
    return _BuatJurnalPageState();
  }
}

class _BuatJurnalPageState extends State<BuatJurnalPage> {
  late final TextEditingController _kelasController;
  late final TextEditingController _mapelController;
  late final TextEditingController _tujuanController;
  late final TextEditingController _materiController;
  late final TextEditingController _kegiatanController;
  late final TextEditingController _dimensiController;

  int jamKe = 0;

  @override
  void initState() {
    super.initState();
    final j = widget.jurnal;
    _kelasController = TextEditingController(text: j?.kelas ?? '');
    _mapelController = TextEditingController(text: j?.mapel ?? '');
    _tujuanController = TextEditingController(
      text: j?.tujuanPembelajaran ?? '',
    );
    _materiController = TextEditingController(
      text: j?.materiTopikPembelajaran ?? '',
    );
    _kegiatanController = TextEditingController(
      text: j?.kegiatanPembelajaran ?? '',
    );
    _dimensiController = TextEditingController(
      text: j?.dimensiProfilPelajarPancasila ?? '',
    );
    jamKe = j?.jam ?? 0;
  }

  @override
  void dispose() {
    _kelasController.dispose();
    _mapelController.dispose();
    _tujuanController.dispose();
    _materiController.dispose();
    _kegiatanController.dispose();
    _dimensiController.dispose();
    super.dispose();
  }

  Widget _textArea(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: hint,
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Future<void> _saveJurnal(BuildContext context) async {
    DataProvider provider = context.read<DataProvider>();

    if (widget.jurnal != null) {
      Jurnal updatedJurnal = Jurnal(
        id: widget.jurnal!.id,
        kelas: _kelasController.text,
        mapel: _mapelController.text,
        jam: jamKe,
        tujuanPembelajaran: _tujuanController.text,
        materiTopikPembelajaran: _materiController.text,
        kegiatanPembelajaran: _kegiatanController.text,
        dimensiProfilPelajarPancasila: _dimensiController.text,
        createdAt: widget.jurnal!.createdAt,
      );
      await provider.ubahJurnal(updatedJurnal);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jurnal berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } else {
      Jurnal jurnal = Jurnal(
        kelas: _kelasController.text,
        mapel: _mapelController.text,
        jam: jamKe,
        tujuanPembelajaran: _tujuanController.text,
        materiTopikPembelajaran: _materiController.text,
        kegiatanPembelajaran: _kegiatanController.text,
        dimensiProfilPelajarPancasila: _dimensiController.text,
      );
      await provider.tambahJurnal(jurnal);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jurnal berhasil disimpan')),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kelas:'),
              const SizedBox(height: 10),
              TextField(
                controller: _kelasController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Kelas',
                ),
              ),
              const SizedBox(height: 10),
              const Text('Nama Mapel'),
              const SizedBox(height: 10),
              TextField(
                controller: _mapelController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Nama Mapel',
                ),
              ),
              const SizedBox(height: 10),
              const Text('Jam Ke-'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: (jamKe >= 1 && jamKe <= 8) ? jamKe.toString() : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pilih Jam',
                ),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('1')),
                  DropdownMenuItem(value: '2', child: Text('2')),
                  DropdownMenuItem(value: '3', child: Text('3')),
                  DropdownMenuItem(value: '4', child: Text('4')),
                  DropdownMenuItem(value: '5', child: Text('5')),
                  DropdownMenuItem(value: '6', child: Text('6')),
                  DropdownMenuItem(value: '7', child: Text('7')),
                  DropdownMenuItem(value: '8', child: Text('8')),
                ],
                onChanged: (value) {
                  setState(() {
                    jamKe = int.tryParse(value ?? '') ?? 0;
                  });
                },
              ),
              const SizedBox(height: 10),
              _textArea(
                'Tujuan Pembelajaran',
                'Masukkan Tujuan Pembelajaran',
                _tujuanController,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Materi/Topik Pembelajaran',
                'Masukkan Materi/Topik Pembelajaran',
                _materiController,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Kegiatan Pembelajaran',
                'Masukkan Kegiatan Pembelajaran',
                _kegiatanController,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Dimensi Profil Pelajar Pancasila',
                'Tuliskan Dimensi Profil Pelajar Pancasila',
                _dimensiController,
              ),
              const SizedBox(height: 10),
              const Text('Foto Kegiatan'),
              const SizedBox(height: 10),
              const MediaSelector(),
              const SizedBox(height: 10),
              const Text('Video Kegiatan'),
              const SizedBox(height: 10),
              const MediaSelector(mediaType: MediaType.video),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveJurnal(context),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
