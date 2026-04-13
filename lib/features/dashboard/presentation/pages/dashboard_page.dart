import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Memerintahkan Provider untuk "Fetch Data" ke Golang 
    // sesaat setelah halaman ini selesai digambar pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Memantau (watch) segala perubahan state di ProductProvider
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Warna latar abu-abu terang
      appBar: AppBar(
        title: const Text('Dashboard Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5D4037), // Coklat Earth Tone
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<ProductProvider>().fetchProducts(),
          ),
        ],
      ),
      // 8.4 UI Merespons State dengan switch
      body: _buildBody(provider),
    );
  }

  /// Fungsi untuk merespons State dengan menggunakan switch (Dart 3)
  Widget _buildBody(ProductProvider provider) {
    // Logika Switch: "Berdasarkan kondisi provider, tampilkan UI yang sesuai"
    return switch (provider) {
      // 1. State: Sedang Loading
      _ when provider.isLoading => const Center(
          child: CircularProgressIndicator(color: Color(0xFF5D4037)),
        ),
        
      // 2. State: Terjadi Error dari Backend
      _ when provider.errorMessage != null => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(provider.errorMessage!, textAlign: TextAlign.center),
            ],
          ),
        ),
        
      // 3. State: Data Berhasil Diambil, tapi Kosong (0 produk)
      _ when provider.products.isEmpty => const Center(
          child: Text('Belum ada produk yang tersedia.', style: TextStyle(fontSize: 16)),
        ),
        
      // 4. State: Sukses! Tampilkan List Produk
      _ => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Nanti kita ganti dengan gambar asli pakai Image.network
                  child: const Icon(Icons.image, color: Colors.grey), 
                ),
                title: Text(
                  product.name, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0), // <--- INI BIANG KEROKNYA SUDAH DIPERBAIKI
                  child: Text(
                    'Rp ${product.price.toStringAsFixed(0)}', 
                    style: const TextStyle(color: Color(0xFF8D6E63), fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Nanti untuk navigasi ke halaman Detail
                },
              ),
            );
          },
        ),
    };
  }
}