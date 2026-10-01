import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kuis_si_a/models/destination_model.dart';

// Halaman Detail Destinasi Wisata.
// Menggunakan StatefulWidget karena halaman ini perlu mengelola state lokal,
// yaitu status "Favorit" (aktif/tidak aktif) yang dapat berubah dan disimpan secara persisten.
class DetailPage extends StatefulWidget {
  // Objek destination diterima melalui constructor saat navigasi dari ListPage
  final Destination destination;

  const DetailPage({super.key, required this.destination});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // State untuk menyimpan status apakah destinasi ini difavoritkan atau tidak
  bool _isFavorite = false;

  // State indikator saat membaca data dari SharedPreferences
  bool _isLoadingPreference = true;

  // initState() adalah lifecycle method yang pertama kali dijalankan
  // ketika widget dibuat sebelum method build() dieksekusi.
  @override
  void initState() {
    super.initState();
    // Membaca status favorit yang tersimpan di memori lokal HP saat halaman dibuka
    _loadFavoriteStatus();
  }

  // Fungsi async untuk membaca data favorite dari SharedPreferences berdasarkan ID destinasi
  Future<void> _loadFavoriteStatus() async {
    // Mengambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Kunci unik dibuat berdasarkan ID destinasi (misal: 'favorite_dest_01')
    // agar status favorit tidak tertukar antar destinasi wisata.
    final key = 'favorite_${widget.destination.id}';

    // Membaca nilai boolean dari storage lokal; jika null (belum pernah diset), default false
    final savedFavorite = prefs.getBool(key) ?? false;

    // Memastikan widget masih terpasang pada widget tree (mounted) sebelum memanggil setState
    if (mounted) {
      // setState digunakan untuk memberi tahu framework Flutter bahwa state internal berubah,
      // sehingga Flutter akan me-render ulang (re-build) tampilan UI dengan nilai baru.
      setState(() {
        _isFavorite = savedFavorite;
        _isLoadingPreference = false;
      });
    }
  }

  // Fungsi async untuk mengubah status favorit dan menyimpannya secara persisten ke SharedPreferences
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorite_${widget.destination.id}';

    // Membalik nilai status favorit saat ini
    final newStatus = !_isFavorite;

    // Menyimpan perubahan status (true / false) ke SharedPreferences secara permanen
    await prefs.setBool(key, newStatus);

    if (mounted) {
      // Memperbarui UI secara langsung dengan setState
      setState(() {
        _isFavorite = newStatus;
      });

      // Menampilkan feedback visual kepada pengguna melalui SnackBar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                newStatus ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                newStatus
                    ? '${widget.destination.name} ditambahkan ke Favorit!'
                    : '${widget.destination.name} dihapus dari Favorit',
              ),
            ],
          ),
          backgroundColor: newStatus ? Colors.redAccent : Colors.grey[800],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Fungsi untuk membuka tautan URL Wikipedia di web browser pengguna
  Future<void> _openWikipedia() async {
    final Uri uri = Uri.parse(widget.destination.wikiUrl);
    try {
      // canLaunchUrl memeriksa apakah device mendukung pembukaan tautan URL tersebut
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka URL';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka tautan: ${widget.destination.wikiUrl}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dest = widget.destination;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Tombol Back manual di AppBar menggunakan Navigator.pop untuk kembali ke halaman sebelumnya
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Daftar',
          onPressed: () {
            // Navigator.pop menghapus route saat ini dari stack dan kembali ke ListPage
            Navigator.pop(context);
          },
        ),
        title: Text(
          dest.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // CRITICAL BONUS REQUIREMENT: Tombol Favorit (Heart Icon) di AppBar
          _isLoadingPreference
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  tooltip: _isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                  // Mengubah icon: outline jika belum favorit, filled merah jika sudah favorit
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.redAccent : Colors.white,
                    size: 26,
                  ),
                  onPressed: _toggleFavorite, // Memanggil fungsi toggle dan save SharedPreferences
                ),
        ],
      ),
      // SingleChildScrollView agar halaman detail dapat di-scroll dengan mulus pada layar kecil
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Destinasi Wisata
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: Image.network(
                    dest.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Overlay gradasi gelap halus di bagian bawah gambar agar teks kontras
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Badge Kategori Wisata di atas gambar
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dest.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Konten Detail Destinasi
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Destinasi
                  Text(
                    dest.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lokasi Destinasi dengan icon pin
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          dest.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Favorit Indicator Card di dalam body
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isFavorite
                          ? Colors.red.withValues(alpha: 0.08)
                          : Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isFavorite
                            ? Colors.redAccent.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.redAccent : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _isFavorite
                                ? 'Destinasi ini ada dalam daftar Favorit Anda (Tersimpan di SharedPreferences)'
                                : 'Belum ditambahkan ke Favorit. Ketuk ikon hati di atas untuk menyimpan.',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isFavorite ? Colors.red[800] : Colors.grey[700],
                              fontWeight: _isFavorite ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Garis pembatas (Divider)
                  const Divider(),
                  const SizedBox(height: 12),

                  // Bagian Deskripsi
                  const Text(
                    'Deskripsi Lengkap',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dest.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.6,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bagian Referensi Wikipedia
                  const Text(
                    'Referensi & Sumber Bacaan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tampilan link dan tombol buka Wikipedia
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language_rounded, color: Colors.teal, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Artikel Wikipedia:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dest.wikiUrl,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal[800],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _openWikipedia,
                            icon: const Icon(Icons.open_in_new_rounded, size: 18),
                            label: const Text('Buka Halaman Wikipedia'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
