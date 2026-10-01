// Model data untuk merepresentasikan objek destinasi wisata.
// Model ini digunakan untuk membuat struktur data yang terorganisir dan tipe aman (type-safe).
class Destination {
  // Atribut unik untuk identifikasi destinasi, sangat penting untuk penyimpanan state (SharedPreferences)
  final String id;

  // Nama tempat destinasi wisata
  final String name;

  // Kategori destinasi (misal: Budaya & Sejarah, Wisata Bahari, Alam, dll.)
  final String category;

  // Lokasi wilayah destinasi wisata (Kota / Kabupaten, Provinsi)
  final String location;

  // URL gambar dari internet (network image)
  final String image;

  // Deskripsi lengkap mengenai destinasi wisata
  final String description;

  // Tautan referensi ke halaman Wikipedia untuk informasi lebih lanjut
  final String wikiUrl;

  // Constructor menggunakan named parameter dengan keyword 'required'
  // untuk memastikan semua data wajib diisi saat pembuatan objek.
  const Destination({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.image,
    required this.description,
    required this.wikiUrl,
  });
}

// Kumpulan data dummy destinasi wisata terkenal di Indonesia.
// List ini dapat langsung dipanggil pada halaman list (ListView.builder).
final List<Destination> dummyDestinations = [
  const Destination(
    id: 'dest_01',
    name: 'Candi Borobudur',
    category: 'Budaya & Sejarah',
    location: 'Magelang, Jawa Tengah',
    image: 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1000&q=80',
    description:
        'Candi Borobudur adalah candi Buddha terbesar di dunia yang dibangun pada abad ke-9 pada masa Wangsa Syailendra. Bangunan megah ini dihiasi oleh ribuan relief berukir dan ratusan stupa yang menghadap ke pemandangan perbukitan Menoreh yang menawan. Borobudur diakui sebagai salah satu Situs Warisan Dunia UNESCO dan menjadi magnet pariwisata serta tempat ibadah suci umat Buddha.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Borobudur',
  ),
  const Destination(
    id: 'dest_02',
    name: 'Kepulauan Raja Ampat',
    category: 'Wisata Bahari',
    location: 'Papua Barat Daya',
    image: 'https://images.unsplash.com/photo-1516690561799-46d8f74f9abf?auto=format&fit=crop&w=1000&q=80',
    description:
        'Raja Ampat merupakan gugusan kepulauan karang spektakuler di ujung timur Indonesia. Terkenal sebagai episentrum keanekaragaman hayati laut dunia (Coral Triangle), kawasan ini memiliki lebih dari 75% spesies karang dunia dan ribuan jenis biota laut. Raja Ampat adalah surga bagi penyelam, fotografer lanskap, dan penikmat alam bawah laut.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Kepulauan_Raja_Ampat',
  ),
  const Destination(
    id: 'dest_03',
    name: 'Taman Nasional Komodo',
    category: 'Konservasi & Alam',
    location: 'Manggarai Barat, NTT',
    image: 'https://images.unsplash.com/photo-1578469550956-0e16b69c6a3d?auto=format&fit=crop&w=1000&q=80',
    description:
        'Taman Nasional Komodo terdiri atas pulau-pulau vulkanis termasuk Pulau Komodo, Rinca, dan Padar. Tempat ini merupakan satu-satunya habitat alami komodo (Varanus komodoensis), kadal purba terbesar di dunia. Selain melihat komodo, wisatawan dapat menikmati panorama bukit savanna ikonik dan pantai pasir merah muda (Pink Beach).',
    wikiUrl: 'https://id.wikipedia.org/wiki/Taman_Nasional_Komodo',
  ),
  const Destination(
    id: 'dest_04',
    name: 'Gunung Bromo',
    category: 'Pegunungan & Vulkanik',
    location: 'Probolinggo, Jawa Timur',
    image: 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=1000&q=80',
    description:
        'Gunung Bromo terkenal dengan kaldera raksasa, lautan pasir (Pasir Berbisik), dan kawah aktif yang terus mengepulkan asap belerang. Pemandangan matahari terbit (sunrise) dari Penanjakan berlatar belakang Gunung Batok dan Gunung Semeru merupakan salah satu lanskap alam paling ikonik di Indonesia.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Gunung_Bromo',
  ),
  const Destination(
    id: 'dest_05',
    name: 'Danau Toba',
    category: 'Danau Vulkanik & Budaya',
    location: 'Sumatera Utara',
    image: 'https://images.unsplash.com/photo-1628003668812-70b5711681ba?auto=format&fit=crop&w=1000&q=80',
    description:
        'Danau Toba adalah danau vulkanik terbesar di Asia Tenggara dan salah satu yang terdalam di dunia, terbentuk akibat letusan gunung supervulkan dahsyat ribuan tahun lalu. Di tengah danau megah ini terdapat Pulau Samosir yang menyimpan kekayaan tradisi, seni arsitektur, dan adat istiadat suku Batak Toba yang sangat memikat.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Danau_Toba',
  ),
  const Destination(
    id: 'dest_06',
    name: 'Kawah Ijen',
    category: 'Fenomena Alam & Kawah',
    location: 'Banyuwangi, Jawa Timur',
    image: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=1000&q=80',
    description:
        'Kawah Ijen merupakan danau kawah asam berwarna toska paling menawan di dunia. Daya tarik utamanya adalah fenomena api biru (Blue Fire) yang sangat langka di dunia, hanya bisa disaksikan saat dini hari sebelum matahari terbit, serta aktivitas para penambang belerang tradisional yang tangguh.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Gunung_Ijen',
  ),
  const Destination(
    id: 'dest_07',
    name: 'Tana Toraja',
    category: 'Budaya & Tradisi',
    location: 'Sulawesi Selatan',
    image: 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?auto=format&fit=crop&w=1000&q=80',
    description:
        'Tana Toraja menawarkan pengalaman wisata budaya yang sangat unik dengan rumah adat Tongkonan beratap menyerupai perahu, makam gua batu gantung di tebing Lemo, serta upacara pemakaman adat Rambu Solo yang agung. Lanskap alam perbukitan dan persawahan terasering hijau semakin mempercantik atmosfer mistis daerah ini.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Kabupaten_Tana_Toraja',
  ),
  const Destination(
    id: 'dest_08',
    name: 'Pantai Kelingking Nusa Penida',
    category: 'Wisata Pantai & Panorama',
    location: 'Klungkung, Bali',
    image: 'https://images.unsplash.com/photo-1570789210967-2cac24afeb00?auto=format&fit=crop&w=1000&q=80',
    description:
        'Pantai Kelingking memiliki tebing karang unik yang menyerupai bentuk kepala dinosaurus T-Rex yang menjorok ke Samudra Hindia. Pemandangan tebing kapur putih berpadu dengan air laut biru kehijauan yang jernih dan deburan ombak menjadikannya salah satu sudut foto paling viral di Pulau Dewata.',
    wikiUrl: 'https://id.wikipedia.org/wiki/Nusa_Penida',
  ),
];
