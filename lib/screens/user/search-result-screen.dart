import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/models/product-model.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<ProductModel> searchResults;

  SearchResultsScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: searchResults.isEmpty
          ? Center(child: Text("No products found."))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                ProductModel product = searchResults[index];
                return ListTile(
                  title: Text(product.productName),
                  subtitle: Text('Sale Price: ${product.salePrice}'),
                  leading: CachedNetworkImage(
                    imageUrl: product.productImages[0],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productModel: product,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
