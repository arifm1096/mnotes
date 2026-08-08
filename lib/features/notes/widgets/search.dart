import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mnotes/providers/search_provider.dart';

class SearchWidget extends ConsumerWidget {
  // Masalah Konstruktor: Parameter sebelumnya didefinisikan tetapi tidak digunakan.
  // Inisialisasi controller harus dilakukan di parent widget dan diteruskan.
  final TextEditingController searchController;

  // Hapus variabel static yang tidak digunakan untuk Stack rumit.
  static const borderRadius = 1.0; // Gunakan radius sudut yang wajar

  // Perbaikan Konstruktor untuk menggunakan 'this'
  SearchWidget({super.key, required this.searchController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50, // Sesuaikan tinggi sesuai keinginan Anda
        decoration: BoxDecoration(
          color: Colors.pinkAccent, // Gunakan warna pink cerah sesuai gambar
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.black, width: 2), // Border hitam pekat
          boxShadow: [
            // BAYANGAN KERAS (HARD SHADOW)
            // Kunci utama: blurRadius 0 dan offset besar
            BoxShadow(
              color: Colors.black, // Warna bayangan pekat
              offset: Offset(5, 5), // Offset besar (kanan bawah)
              blurRadius: 0, // Tanpa keburaman untuk hard shadow
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            // Update provider di sini
            ref.read(searchProvider.notifier).state = value;
          },
          style: const TextStyle(color: Colors.black), // Warna teks kontras
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10), // Tengahkan teks
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black, // Warna ikon kontras
            ),
            hintText: 'Search Notes',
            hintStyle: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}