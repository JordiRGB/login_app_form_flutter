import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-4ee3c-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  final storage = FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsServices() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'Products.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final response = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(response.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
  }

  Future saveorCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Products/${product.id}.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final response = await http.put(url, body: product.toJson());
    final decodeData = response.body;
    print(decodeData);
    //TODO: Actualizar listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Products.json', {
      'auth': await storage.read(key: 'token') ?? '',
    });
    final response = await http.post(url, body: product.toJson());
    final decodeData = json.decode(response.body);

    product.id = decodeData['name'];

    products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File(path); // <-- cambio aquí
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/dbvnqr9pe/image/upload?upload_preset=products070201',
    );

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Error al subir imagen');
      print('Código: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      return null;
    }

    final decodedData = json.decode(response.body);
    return decodedData['secure_url'];
  }
}
