import 'package:flutter/material.dart';
import 'package:MyDJ/data/data_provider.dart';
import 'package:MyDJ/data/jurnal.dart';
import 'package:MyDJ/pages/detail_jurnal_page.dart';
import 'package:provider/provider.dart';

class LihatJurnalPage extends StatefulWidget {
  const LihatJurnalPage({super.key});

  final String title = 'Lihat Jurnal';

  @override
  State<LihatJurnalPage> createState() {
    return _LihatJurnalPageState();
  }
}

class _LihatJurnalPageState extends State<LihatJurnalPage> {
  @override
  void initState() {
    super.initState();
    context.read<DataProvider>().muatJurnal();
  }

  @override
  Widget build(BuildContext context) {
    final List<Jurnal> daftarJurnal = context
        .watch<DataProvider>()
        .jurnalTersimpan;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  title: Text(daftarJurnal[index].kelas),
                  subtitle: Text(
                    '${daftarJurnal[index].mapel}\n${daftarJurnal[index].createdAt}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<DataProvider>().hapusJurnal(
                        daftarJurnal[index].id!,
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailJurnalPage(jurnal: daftarJurnal[index]),
                      ),
                    );
                  },
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: daftarJurnal.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
