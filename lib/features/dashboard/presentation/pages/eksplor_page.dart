import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/eksplor_product.dart';
import 'product_detail_page.dart';

class EksplorPage extends StatefulWidget {
  const EksplorPage({super.key});

  @override
  State<EksplorPage> createState() => _EksplorPageState();
}

class _EksplorPageState extends State<EksplorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // 1. Bilah Pencarian
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Rantai, Cincin, Gelang...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 8),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.grey.shade700),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildGridBody(),
    );
  }

  Widget _buildGridBody() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF5D4037)),
          );
        }

        // Tampilkan Pesan Error Merah
        if (provider.errorMessage != null) {
          return Center(
            child: Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (provider.products.isEmpty) {
          return const Center(child: Text('Katalog masih kosong...'));
        }

        // 3. GridView: Menampilkan 2 kolom produk berdampingan 
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return EksplorProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
