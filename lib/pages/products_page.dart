import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/l10n.dart'; // Import the localization class
import '../providers/product_state.dart';
import '../providers/product_provider.dart';
import 'product_detail_page.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  void _navigateToProductDetails(BuildContext context, int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final locale = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.translate('title')),
        backgroundColor: Colors.amberAccent,
      ),
      body: _buildBody(context, ref, productState, locale),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
    L10n locale,
  ) {
    switch (state.status) {
      case ProductStateStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ProductStateStatus.success:
        return RefreshIndicator(
          onRefresh: () => ref.read(productProvider.notifier).refreshProducts(),
          child:
              state.products.isEmpty
                  ? Center(
                    child: Text(
                      locale.translate('noProductsFound'),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: state.products.length,
                    reverse: Directionality.of(context) == TextDirection.rtl,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CarouselSlider(
                                  items:
                                      product.images.map((image) {
                                        return Image.network(
                                          image.url,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.fill,
                                        );
                                      }).toList(),
                                  options: CarouselOptions(
                                    height: 150,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration: Duration(
                                      milliseconds: 800,
                                    ),
                                    viewportFraction: 0.8,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  subtitle: Text(
                                    product.description,
                                    overflow:
                                        TextOverflow
                                            .ellipsis, // Truncate with ellipsis
                                    maxLines: 3,
                                  ),
                                  onTap:
                                      () => _navigateToProductDetails(
                                        context,
                                        product.id,
                                      ),
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        locale
                                            .translate('price')
                                            .replaceFirst(
                                              '{price}',
                                              product.price.toStringAsFixed(2),
                                            ),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed:
                                          () => _navigateToProductDetails(
                                            context,
                                            product.id,
                                          ),
                                      label: Text(locale.translate('details')),
                                      icon: const Icon(
                                        Icons.forward,
                                        size: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
        );

      case ProductStateStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed:
                    () => ref.read(productProvider.notifier).loadProducts(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case ProductStateStatus.initial:
        return const SizedBox.shrink();
    }
  }
}
