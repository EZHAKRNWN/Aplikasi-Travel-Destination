import 'package:flutter/material.dart';
import 'package:kuis_si_a/models/destination_model.dart';
import 'package:kuis_si_a/screens/detail_page.dart';
import 'package:kuis_si_a/screens/login_page.dart';

// Halaman Daftar Destinasi Wisata.
// Menggunakan StatelessWidget karena data daftar destinasi diambil dari list statis dummyDestinations
// dan tidak mengalami perubahan state secara langsung pada halaman ini.
class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Destinasi Wisata',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Tombol Logout untuk kembali ke halaman Login
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar',
            onPressed: () {
              // Dialog konfirmasi sebelum logout
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Keluar'),
                  content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        // Menggunakan Navigator.pushReplacement untuk kembali ke LoginPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Keluar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // ListView.builder digunakan untuk menampilkan daftar item secara dinamis dan efisien.
      // Widget ini hanya membuat (render) item yang sedang terlihat pada layar pengguna (lazy loading),
      // sehingga sangat hemat memori untuk data dalam jumlah banyak.
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        // itemCount menentukan jumlah total item yang akan dirender berdasarkan panjang list dummy
        itemCount: dummyDestinations.length,
        // itemBuilder merupakan callback function yang dipanggil untuk membangun widget pada setiap indeks
        itemBuilder: (context, index) {
          // Mengambil objek destinasi tunggal berdasarkan indeks saat ini
          final destination = dummyDestinations[index];

          // Menggunakan Card untuk membungkus setiap item destinasi agar memiliki batas visual dan bayangan (elevation)
          return Card(
            margin: const EdgeInsets.only(bottom: 14.0),
            elevation: 2.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias, // Memastikan gambar memotong sudut rounded card dengan rapi
            child: InkWell(
              // InkWell memberikan efek sentuhan ripple (gelombang air) saat item diklik oleh pengguna
              onTap: () {
                // Menggunakan Navigator.push untuk berpindah ke halaman DetailPage.
                // Objek 'destination' spesifik dikirim melalui constructor DetailPage (Passing Data via Routing).
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(destination: destination),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widget untuk menampilkan gambar destinasi
                  // ClipRRect memberikan sudut melengkung pada sisi kiri gambar
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.network(
                        destination.image,
                        fit: BoxFit.cover,
                        // loadingBuilder menampilkan indikator loading saat gambar sedang diunduh dari internet
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.teal,
                              ),
                            ),
                          );
                        },
                        // errorBuilder menangani jika URL gambar gagal dimuat (misal offline atau broken link)
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image_rounded,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Kolom untuk menampilkan informasi teks (Nama, Kategori, dan Lokasi)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge / Chip kecil untuk kategori destinasi
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 3.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              destination.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Nama Destinasi Wisata
                          Text(
                            destination.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),

                          // Lokasi Destinasi Wisata dengan icon pin
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  destination.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Teks bantuan navigasi menuju detail
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Lihat Detail',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[700],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: Colors.teal[700],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
