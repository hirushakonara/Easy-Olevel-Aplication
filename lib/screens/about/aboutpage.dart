import 'package:easyol/core/constants.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: kPrimaryBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Logo එකක් හෝ Icon එකක්
            const Icon(Icons.school, size: 100, color: kPrimaryBlue),
            const SizedBox(height: 20),

            const Text(
              "EduApp Connect",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            // සමාගම ගැන විස්තර
            const Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "අපගේ ආයතනය O/L සිසුන් සඳහා ගුණාත්මක අධ්‍යාපනික සම්පත් ලබා දීමට කැපවී සිටී. "
                  "ගණිතය සහ ICT විෂයයන් සඳහා සරල සහ පහසු ඉගෙනුම් ක්‍රමවේදයක් අපගේ App එක හරහා ඔබට ලබාගත හැක.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // සම්බන්ධතා තොරතුරු
            ListTile(
              leading: const Icon(Icons.email, color: kPrimaryPurple),
              title: const Text("info@yourcompany.com"),
              onTap: () {
                // Email link එකක් දාන්න පුළුවන්
              },
            ),
            ListTile(
              leading: const Icon(Icons.web, color: kPrimaryPurple),
              title: const Text("www.yourwebsite.com"),
              onTap: () {
                // Website එකට යන්න
              },
            ),
          ],
        ),
      ),
    );
  }
}
