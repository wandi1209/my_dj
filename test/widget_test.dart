import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:MyDJ/data/data_provider.dart';
import 'package:MyDJ/data/jurnal.dart';
import 'package:MyDJ/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpApp(WidgetTester tester, DataProvider provider) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(value: provider, child: const MyApp()),
  );
  await tester.pumpAndSettle();
}

Future<void> _login(WidgetTester tester) async {
  final Finder usernameField = find.byWidgetPredicate(
    (widget) =>
        widget is TextField && widget.decoration?.labelText == 'Username',
  );
  await tester.enterText(usernameField, 'guru');
  await tester.enterText(find.byType(TextFormField), 'guru');
  await tester.ensureVisible(find.text('Login'));
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Menampilkan dan menggunakan halaman login', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester, DataProvider());

    expect(find.text('MyDJ - Welcome'), findsOneWidget);
    expect(find.text('Log-In'), findsOneWidget);
    expect(find.text('Nama Pengguna:'), findsOneWidget);
    expect(find.text('Sandi:'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    await _login(tester);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Lihat Jurnal'), findsOneWidget);
    expect(find.text('Buat Jurnal'), findsOneWidget);
    expect(find.text('Akun'), findsOneWidget);
    expect(find.text('Tentang Aplikasi'), findsOneWidget);
  });

  testWidgets('Menampilkan halaman akun', (WidgetTester tester) async {
    await _pumpApp(tester, DataProvider());
    await _login(tester);
    await tester.tap(find.text('Akun'));
    await tester.pumpAndSettle();

    expect(find.text('Ganti Sandi'), findsOneWidget);
    expect(find.text('Sandi Saat Ini'), findsOneWidget);
    expect(find.text('Sandi Baru'), findsOneWidget);
    expect(find.text('Konfirmasi Sandi Baru'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
    expect(find.text('Keluar dari Aplikasi'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
  });

  testWidgets('Menampilkan formulir jurnal dan pemilih media', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester, DataProvider());
    await _login(tester);

    await tester.tap(find.text('Buat Jurnal'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '3A');
    await tester.enterText(find.byType(TextField).at(1), 'Bahasa Indonesia');
    await tester.tap(find.text('Pilih Jam'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(2), 'Membaca teks');
    await tester.enterText(find.byType(TextField).at(3), 'Teks narasi');
    await tester.enterText(find.byType(TextField).at(4), 'Diskusi');
    await tester.enterText(find.byType(TextField).at(5), 'Gotong royong');

    expect(find.text('No photo'), findsOneWidget);
    expect(find.text('No video'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);
  });

  test('Mengonversi jurnal ke Map dan kembali menjadi objek', () {
    final DateTime createdAt = DateTime.parse('2026-11-18T08:00:00.000');
    final Jurnal jurnal = Jurnal(
      id: 7,
      kelas: '3A',
      mapel: 'Bahasa Indonesia',
      jam: 1,
      tujuanPembelajaran: 'Membaca teks',
      materiTopikPembelajaran: 'Teks narasi',
      kegiatanPembelajaran: 'Diskusi',
      dimensiProfilPelajarPancasila: 'Gotong royong',
      createdAt: createdAt,
    );

    final Jurnal hasil = Jurnal.fromMap(jurnal.toMap());

    expect(hasil.id, 7);
    expect(hasil.kelas, '3A');
    expect(hasil.mapel, 'Bahasa Indonesia');
    expect(hasil.jam, 1);
    expect(hasil.tujuanPembelajaran, 'Membaca teks');
    expect(hasil.materiTopikPembelajaran, 'Teks narasi');
    expect(hasil.kegiatanPembelajaran, 'Diskusi');
    expect(hasil.dimensiProfilPelajarPancasila, 'Gotong royong');
    expect(hasil.createdAt, createdAt);
  });

  testWidgets('Mempertahankan dan menghapus sesi login', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester, DataProvider());
    await _login(tester);
    expect(find.text('Beranda'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await _pumpApp(tester, DataProvider());
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Login'), findsNothing);

    await tester.tap(find.text('Akun'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Keluar dari Aplikasi'));
    await tester.tap(find.text('Keluar dari Aplikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await _pumpApp(tester, DataProvider());
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Beranda'), findsNothing);
  });
}
