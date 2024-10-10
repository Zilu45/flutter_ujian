import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Menyimpan status tema (light/dark)
  bool _isDarkTheme = false;

  // Fungsi untuk mengganti tema
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pengelompokan Nilai Siswa',
      theme: ThemeData.light(), // Tema terang
      darkTheme: ThemeData.dark(), // Tema gelap
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light, // Mengatur mode tema
      home: HomeScreen(
        toggleTheme: _toggleTheme, // Mengoper fungsi untuk mengganti tema
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  HomeScreen({required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nilaiController = TextEditingController();
  String _kategori = '';
  List<int> _nilaiList = []; // List untuk menyimpan nilai yang diinput

  // Fungsi untuk menghitung kategori nilai berdasarkan input
  void _hitungKategori() {
    if (_formKey.currentState!.validate()) {
      int nilai = int.parse(_nilaiController.text);
      _nilaiList.add(nilai); // Menambahkan nilai ke dalam list

      setState(() {
        _kategori = _getKategori(nilai);
      });

      // Menampilkan SnackBar saat nilai ditambahkan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nilai $nilai ditambahkan!')),
      );

      _nilaiController.clear(); // Bersihkan field input setelah nilai dimasukkan
    }
  }

  // Fungsi untuk mendapatkan kategori berdasarkan nilai
  String _getKategori(int nilai) {
    if (nilai >= 85) {
      return 'A';
    } else if (nilai >= 70) {
      return 'B';
    } else if (nilai >= 55) {
      return 'C';
    } else {
      return 'D';
    }
  }

  // Fungsi untuk menghitung rata-rata nilai
  double _hitungRataRata() {
    if (_nilaiList.isEmpty) return 0;
    return _nilaiList.reduce((a, b) => a + b) / _nilaiList.length;
  }

  // Fungsi untuk menghapus nilai yang telah diinput dari daftar
  void _hapusNilai(int index) {
    setState(() {
      int nilaiDihapus = _nilaiList[index];
      _nilaiList.removeAt(index);

      // Menampilkan SnackBar saat nilai dihapus
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nilai $nilaiDihapus dihapus!')),
      );
    });
  }

  // Fungsi validasi input nilai
  String? _validateNilai(String? value) {
    if (value == null || value.isEmpty) {
      return 'Masukkan nilai siswa'; // Pesan kesalahan jika kosong
    }
    final int? nilai = int.tryParse(value);
    if (nilai == null) {
      return 'Nilai harus berupa angka'; // Pesan kesalahan jika bukan angka
    } else if (nilai < 0 || nilai > 100) {
      return 'Nilai harus di antara 0 - 100'; // Pesan kesalahan jika di luar rentang
    }
    return null; // Tidak ada kesalahan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengelompokan Nilai Siswa'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme, // Tombol untuk mengganti tema
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input Field untuk memasukkan nilai siswa
              TextFormField(
                controller: _nilaiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Masukkan nilai siswa',
                  border: OutlineInputBorder(),
                ),
                validator: _validateNilai,
              ),
              SizedBox(height: 20),
              // Tombol Hitung untuk menambah nilai ke list dan menampilkan kategori
              ElevatedButton(
                onPressed: _hitungKategori,
                child: Text('Tambah Nilai'),
              ),
              SizedBox(height: 20),
              // Tampilkan daftar nilai yang telah diinput
              Expanded(
                child: ListView.builder(
                  itemCount: _nilaiList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text('Nilai: ${_nilaiList[index]}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapusNilai(index), // Hapus nilai ketika tombol delete ditekan
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Hasil kategori nilai yang ditampilkan
              Text(
                'Kategori: $_kategori',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Menampilkan Rata-Rata Nilai
              Text(
                'Rata-Rata: ${_hitungRataRata().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
