import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class DonationRequestPage extends StatefulWidget {
  @override
  _DonationRequestPageState createState() => _DonationRequestPageState();
}

class _DonationRequestPageState extends State<DonationRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();

  File? _attachmentFile; // To store the selected file
  String? _attachmentUrl; // To store the uploaded file URL

  // Category dropdown
  String? _selectedCategory; // To store the selected category
  final List<String> _categories = [
    "Medical",
    "Education",
    "Clubs",
    "Sports",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Donation"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Your Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Student ID
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(labelText: "Student ID"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your student ID";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Department
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: "Department Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your department";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Faculty
              TextFormField(
                controller: _facultyController,
                decoration: InputDecoration(labelText: "Faculty Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your faculty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Level
              TextFormField(
                controller: _levelController,
                decoration: InputDecoration(labelText: "Level"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your level";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Semester
              TextFormField(
                controller: _semesterController,
                decoration: InputDecoration(labelText: "Semester"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your semester";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Amount Needed
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount Needed (BDT)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the amount needed";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide a description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a category";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Attachment Upload
              ElevatedButton(
                onPressed: _pickAttachment,
                child: Text("Upload Attachment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 8),
              Text(
                _attachmentFile != null
                    ? "Selected File: ${_attachmentFile!.path.split('/').last}"
                    : "No file selected",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitRequest,
                child: Text("Submit Request"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to pick an attachment file
  void _pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _attachmentFile = File(result.files.single.path!);
      });
    }
  }

  // Function to upload the attachment to Firebase Storage
  Future<String?> _uploadAttachment() async {
    if (_attachmentFile == null) return null;

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = _storage.ref().child("attachments/$fileName");
      UploadTask uploadTask = storageReference.putFile(_attachmentFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  // Function to submit the request
  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // Upload attachment (if any)
      String? attachmentUrl = await _uploadAttachment();

      // Save the request to Firestore
      await _firestore.collection('donation_requests').add({
        'name': _nameController.text.trim(),
        'studentId': _studentIdController.text.trim(),
        'department': _departmentController.text.trim(),
        'faculty': _facultyController.text.trim(),
        'level': _levelController.text.trim(),
        'semester': _semesterController.text.trim(),
        'amount': _amountController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory, // Add selected category
        'attachmentUrl': attachmentUrl,
        'date': DateTime.now(),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request submitted successfully!")),
      );

      // Clear the form
      _nameController.clear();
      _studentIdController.clear();
      _departmentController.clear();
      _facultyController.clear();
      _levelController.clear();
      _semesterController.clear();
      _amountController.clear();
      _descriptionController.clear();
      setState(() {
        _attachmentFile = null;
        _selectedCategory = null; // Reset category
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    _facultyController.dispose();
    _levelController.dispose();
    _semesterController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}