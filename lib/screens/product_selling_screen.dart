// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductSellingScreen extends StatefulWidget {
  const ProductSellingScreen({super.key});

  @override
  State<ProductSellingScreen> createState() => _ProductSellingScreenState();
}

class _ProductSellingScreenState extends State<ProductSellingScreen> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  final apiBase = dotenv.env['API_BASE_URL'] ?? '';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _locationController = TextEditingController();
  final _quantityController = TextEditingController();

  bool _isNegotiable = false;
  String _sellingType = 'Retail';
  String _unitType = 'Kg';
  String _status = 'Active';

  String? userType;
  bool isLoading = true;
  bool hasError = false;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  InputDecoration commonInputDecoration({
    required String label,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.paleGreen),
      ),
      labelStyle: TextStyle(color: Colors.grey[700]),
      floatingLabelStyle: TextStyle(color: AppColors.paleGreen),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedFile != null)
      setState(() => _pickedImage = File(pickedFile.path));
  }

  Future<void> _loadUserType() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final type = prefs.getString('userType') ?? 'user';

      setState(() {
        userType = type;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a product photo.")),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not authenticated.")));
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final price = _priceController.text.trim();
    final desc = _descController.text.trim();
    final cultivatedDate = _dateController.text.trim();
    final expiryDate = _expiryDateController.text.trim();
    final location = _locationController.text.trim();
    final quantity = _quantityController.text.trim();

    // Convert image file to base64 string (modify if backend expects differently)
    final imageBytes = await _pickedImage!.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    // Construct your JSON payload according to your backend API
    final Map<String, dynamic> productData = {
      "name": name,
      "category": category,
      "location": location,
      "cultivate_date": cultivatedDate,
      "expiry_date": expiryDate,
      "price": double.tryParse(price) ?? 0,
      "is_negotiable": _isNegotiable,
      "unit_type": _unitType,
      "image": base64Image,
      "status": _status,
      "description": desc,
      "remaining_quantity": int.tryParse(quantity) ?? 0,
    };

    try {
      final response = await http.post(
        Uri.parse('$apiBase/product/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(productData),
      );

      final resData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resData['message'] ?? "Product added successfully!"),
          ),
        );

        _formKey.currentState!.reset();
        setState(() {
          // reset controllers manually to clear the text inside TextFormFields
          _nameController.clear();
          _categoryController.clear();
          _priceController.clear();
          _descController.clear();
          _dateController.clear();
          _expiryDateController.clear();
          _locationController.clear();
          _quantityController.clear();

          // reset other states
          _isNegotiable = false;
          _unitType = 'Kg';
          _sellingType = 'Retail'; // also reset dropdowns if needed
          _status = 'Active';
          _pickedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resData['message'] ?? 'Failed to add product'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Network error: $e")));
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (hasError)
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Something went wrong while loading user data."),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadUserType,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
              ),
            ],
          ),
        ),
      );

    if (userType != 'farmer')
      return Scaffold(
        appBar: AppBar(title: const Text("Restricted")),
        body: const Center(child: Text("Only farmers can access this page")),
      );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.paleGreen,
        title: const Text(
          "Sell Product",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'images/LoginBackround.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      "Post Your Product - Start Selling Today!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.paleGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[200],
                          child: _pickedImage != null
                              ? Image.file(_pickedImage!, fit: BoxFit.cover)
                              : const Center(child: Text('No Image')),
                        ),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text(
                          'Take Photo',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _pickImageFromGallery,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: commonInputDecoration(
                      label: 'Product Name',
                      prefixIcon: Icons.shopping_bag,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter product name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _categoryController,
                    decoration: commonInputDecoration(
                      label: 'Category (e.g., Rice, Egg)',
                      prefixIcon: Icons.category,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter category'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _priceController,
                    decoration: commonInputDecoration(
                      label: 'Price (₹)',
                      prefixIcon: Icons.attach_money,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Enter price';
                      if (double.tryParse(value) == null)
                        return 'Enter valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descController,
                    decoration: commonInputDecoration(
                      label: 'Description',
                      prefixIcon: Icons.description,
                    ),
                    maxLines: 4,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter description'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null)
                        _dateController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(picked);
                    },
                    decoration: commonInputDecoration(
                      label: 'Cultivated Date',
                      prefixIcon: Icons.calendar_month,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter cultivated date'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _expiryDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null)
                        _expiryDateController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(picked);
                    },
                    decoration: commonInputDecoration(
                      label: 'Expiry Date',
                      prefixIcon: Icons.calendar_today,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter expiry date'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _locationController,
                    decoration: commonInputDecoration(
                      label: 'Location',
                      prefixIcon: Icons.location_on,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter location'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _quantityController,
                    decoration: commonInputDecoration(
                      label: 'Remaining Quantity',
                      prefixIcon: Icons.scale,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter quantity'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _sellingType,
                    decoration: commonInputDecoration(
                      label: 'Selling Type',
                      prefixIcon: Icons.straighten,
                    ),
                    items: ['Retail', 'Wholesale'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) =>
                        setState(() => _sellingType = newValue!),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _unitType,
                    decoration: commonInputDecoration(
                      label: 'Unit Type',
                      prefixIcon: Icons.straighten,
                    ),
                    items: ['Kg', 'L'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) =>
                        setState(() => _unitType = newValue!),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: commonInputDecoration(
                      label: 'Status',
                      prefixIcon: Icons.toggle_on,
                    ),
                    items: ['Active', 'Expired'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) =>
                        setState(() => _status = newValue!),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      value: _isNegotiable,
                      title: const Text("Is price negotiable?"),
                      onChanged: (value) {
                        setState(() {
                          _isNegotiable = value ?? false;
                        });
                      },
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : _submitProduct,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, color: Colors.white),
                      label: Text(
                        isSubmitting ? "Submitting..." : "Submit Product",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
