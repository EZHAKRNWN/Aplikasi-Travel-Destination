import 'package:flutter/material.dart';
import 'package:kuis_si_a/screens/login_page.dart';

// Fungsi main() adalah titik awal (entry point) eksekusi seluruh program Flutter.
void main() {
  // WidgetsFlutterBinding.ensureInitialized() memastikan integrasi antara framework Flutter
  // dan host platform (Android/iOS) sudah siap sebelum menjalankan kode async seperti SharedPreferences.
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() melampirkan root widget (MyApp) ke layar perangkat.
  runApp(const MyApp());
}

// MyApp adalah Root Widget aplikasi yang bersifat stateless
// karena konfigurasi global aplikasi (tema, rute, judul) bersifat statis.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp membungkus aplikasi dengan komponen dan konvensi Material Design
    return MaterialApp(
      // Judul aplikasi yang muncul di App Switcher / Task Manager OS
      title: 'Travel Destination',

      // Menonaktifkan pita/banner 'DEBUG' di pojok kanan atas layar
      debugShowCheckedModeBanner: false,

      // Konfigurasi tema global aplikasi (Color scheme, AppBar, Card, dll.)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // Menetapkan halaman pertama yang ditampilkan saat aplikasi dibuka adalah LoginPage
      home: const LoginPage(),
    );
  }
}
