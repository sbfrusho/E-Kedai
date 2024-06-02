import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/models/product-model.dart';
import 'package:shopping_app/screens/user/product-detailscreen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<ProductModel> searchResults;

  const SearchResultsScreen({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: product.productImages[0],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            title: Text(product.productName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sale Price: ${product.salePrice}'),
                Text('Full Price: ${product.fullPrice}'),
              ],
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
