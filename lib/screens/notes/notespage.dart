import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyol/core/constants.dart';
import 'package:easyol/screens/notes/pdf_view_screen.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String selectedGrade = '10';
  String selectedSubject = 'ICT';

  final List<String> grades = ['10', '11'];
  final List<String> subjects = ['ICT', 'Maths'];

  @override
  Widget build(BuildContext context) {
    // Screenshot එකට අනුව නිවැරදි Collection නාමය සකසා ගැනීම
    String collectionName = "notes_grade$selectedGrade";

    // Database එකේ ICT document එක simple අකුරින් (ict) ඇති බැවින් එය හැසිරවීම
    String documentName = selectedSubject == 'ICT' ? 'ict' : selectedSubject;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryBlue,
        title: const Text("Study Notes"),
      ),
      body: Column(
        children: [
          /// Dropdowns
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: selectedGrade,
                  items: grades.map((grade) {
                    return DropdownMenuItem(
                      value: grade,
                      child: Text("Grade $grade"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGrade = value!;
                    });
                  },
                ),

                DropdownButton<String>(
                  value: selectedSubject,
                  items: subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          /// Notes List
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              // නිවැරදි කරනු ලැබූ Firestore path එක
              stream: FirebaseFirestore.instance
                  .collection(collectionName)
                  .doc(documentName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No Notes Found"));
                }

                Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;

                if (data == null || data.isEmpty) {
                  return const Center(child: Text("No Notes Available"));
                }

                List<String> lessons = data.keys.toList();

                return ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    String lesson = lessons[index];
                    String pdfUrl = data[lesson];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        title: Text(lesson),
                        subtitle: const Text("Tap to open PDF"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          debugPrint("Opening PDF: $pdfUrl");

                          // PDF Screen එකට Navigate වීම
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewScreen(
                                pdfUrl: pdfUrl,
                                lessonName: lesson,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
