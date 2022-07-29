import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _initialValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  bool _isInit = true;
  bool _isLoading = false;

  Product _editedProduct = Product.withDefualtProps();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        _initialValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    final value = _imageUrlController.text;

    if (!_imageUrlFocusNode.hasFocus) {
      if (value.isEmpty || !value.startsWith('http')) {
        return;
      }

      setState(() {});
    }
  }

  void _submitHandler() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_editedProduct.id.isEmpty) {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } else {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      }
    } catch (err) {
      await showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text('Something went wrong.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'))
                ],
              )));
    } finally {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    final isEditForm = productId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditForm ? 'Edit Product' : 'Add Product'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        initialValue: _initialValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a title';
                          }

                          return null;
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (newValue) {
                          _editedProduct = Product.fromExistingProduct(
                            _editedProduct,
                            title: newValue,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price must be greater than zero';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) {
                          if (newValue == null || newValue.isEmpty) {
                            newValue = '0.0';
                          }

                          _editedProduct = Product.fromExistingProduct(
                            _editedProduct,
                            price: double.parse(newValue),
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initialValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a description';
                          }
                          if (value.length < 10) {
                            return 'Description should be atleast 10 characters';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product.fromExistingProduct(
                            _editedProduct,
                            description: newValue,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 8, 0),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? const Center(child: Text('Preview'))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              controller: _imageUrlController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please provide an image URL';
                                }
                                if (!value.startsWith('http')) {
                                  return 'Please enter a valid URL';
                                }

                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product.fromExistingProduct(
                                  _editedProduct,
                                  imageUrl: newValue,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _submitHandler,
                        child:
                            Text(isEditForm ? 'Update Product' : 'Add Product'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
