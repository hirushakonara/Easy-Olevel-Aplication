import 'package:easyol/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> userData = {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "school": _schoolController.text.trim(),
          "address": _addressController.text.trim(),
          "grade": _gradeController.text.trim(),
        };

        await Provider.of<AuthProvider>(context, listen: false).registerUser(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          userData: userData,
        );

        // සාර්ථකව Register වූ පසු Homepage වෙත යාම
        Navigator.pushReplacementNamed(context, '/main');
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Registration")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
              TextFormField(
                controller: _schoolController,
                decoration: InputDecoration(labelText: "School"),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Address"),
              ),
              TextFormField(
                controller: _gradeController,
                decoration: InputDecoration(labelText: "Grade (10 or 11)"),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _register, child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
