import 'package:flutter/material.dart';
import 'package:kuis_si_a/screens/list_page.dart';

// Halaman Login menggunakan StatefulWidget karena kita perlu mengelola
// perubahan state seperti input teks dan status visibilitas password.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey untuk validasi Form widget
  final _formKey = GlobalKey<FormState>();

  // TextEditingController digunakan untuk membaca dan mengontrol isi teks
  // pada masing-masing field input (Username dan Password).
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variabel penampung state untuk fitur toggle sembunyikan/tampilkan password
  bool _obscurePassword = true;

  // Method dispose() wajib dipanggil ketika widget dihancurkan (destroyed)
  // guna melepaskan resource controller dari memori (mencegah memory leak).
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani proses login dan validasi kredensial pengguna
  void _handleLogin() {
    // Memeriksa apakah input pada form sudah memenuhi aturan validator masing-masing field
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // STRICT REQUIREMENT: Password harus tepat bernilai "142" (3 digit NIM terakhir mahasiswa)
      if (password == '142') {
        // Menampilkan notifikasi SnackBar berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 8),
                Text('Selamat datang, $username!'),
              ],
            ),
            backgroundColor: Colors.teal[700],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        // Menggunakan Navigator.pushReplacement untuk berpindah ke ListPage.
        // pushReplacement digunakan agar halaman Login dihapus dari stack navigasi,
        // sehingga user tidak bisa kembali ke halaman login hanya dengan tombol 'Back'.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ListPage(),
          ),
        );
      } else {
        // Jika password salah (bukan "142"), tampilkan pesan error melalui SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Password salah! Masukkan 3 digit NIM: 142'),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar Material Design seperti AppBar, Body, SnackBar, dll.
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        // SafeArea memastikan konten UI tidak tertutup oleh status bar atau notch layar hp
        child: Center(
          // SingleChildScrollView mencegah error RenderFlex overflow ketika keyboard muncul
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
            child: Form(
              key: _formKey, // Mengaitkan form dengan GlobalKey untuk validasi
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon dan Ilustrasi Header Aplikasi
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      size: 48,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Judul Aplikasi
                  const Text(
                    'Travel Destination',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Jelajahi Keindahan Wisata Nusantara',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Card pembungkus form input agar tampilan lebih modern dan rapi
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label dan Input Username
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // TextFormField untuk input Username
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama pengguna',
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.teal),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            // Logika validasi: username tidak boleh kosong
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Username tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Label dan Input Password
                          const Text(
                            'Password (3 Digit NIM: 142)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // TextFormField untuk input Password dengan proteksi obscureText
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword, // Menyembunyikan karakter teks password
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Contoh: 142',
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                              suffixIcon: IconButton(
                                // Tombol mata untuk toggle lihat / sembunyikan password
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  // setState digunakan untuk memperbarui UI saat status obscure berubah
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            // Logika validasi: password tidak boleh kosong
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Tombol Login (ElevatedButton)
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'MASUK',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Petunjuk untuk penguji / praktikan kuis
                  Text(
                    '* Gunakan password: 142 untuk berhasil login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
