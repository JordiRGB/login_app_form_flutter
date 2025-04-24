import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import '../providers/product_form_provider.dart';
import '../services/products_service.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductsServices>(context);

    return ChangeNotifierProvider(
        create: (context) =>
            ProductFormProvider(productServices.selectedProduct),
        child: _ProductsScreenBody(productServices: productServices));
    // return _ProductsScreenBody(productServices: productServices);
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    super.key,
    required this.productServices,
  });

  final ProductsServices productServices;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productServices.selectedProduct.picture),
                Positioned(
                  top: 45,
                  left: 20,
                  child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context)),
                ),
                Positioned(
                  top: 45,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined,
                        size: 30, color: Colors.white),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );
                      if (pickedFile == null) {
                        print('No seleccionó ninguna imagen');
                        return;
                      }

                      print('Archivo seleccionado: ${pickedFile.path}');
                      productServices
                          .updateSelectedProductImage(pickedFile.path);
                    },
                  ),
                ),
              ],
            ),
            _ProductForm(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productForm.isValidform()) return;

          String? imageUrl;

          if (productServices.newPictureFile != null) {
            imageUrl = await productServices
                .uploadImage(productServices.newPictureFile!);
            productForm.product.picture = imageUrl ?? '';
          }

          await productServices.saveorCreateProduct(productForm.product);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 280,
        decoration: _builBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => productForm.product.name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El nombre del producto es obligatiorio';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:',
                  suffixIcon: Icon(
                    Icons.production_quantity_limits_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: product.price.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = double.parse(value);
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El precio del producto no puede estar vacío';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '\$999.99',
                  labelText: 'Precio del producto:',
                  suffixIcon: Icon(
                    Icons.attach_money_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('¿Disponible?'),
                activeColor: Colors.blue,
                onChanged: productForm.updateAvailability,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _builBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      );
}
