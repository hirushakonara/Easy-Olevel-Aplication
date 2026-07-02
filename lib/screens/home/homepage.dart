import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // පසුබිමට ලා අළු පැහැයක්
      appBar: AppBar(
        title: const Text(
          "EasyOL Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1 & 2. Profile Card සහ Customizable Countdown Timer එක
            _buildHeaderSection(context),

            // 3. Subject Grid (Categories)
            _buildSubjectGrid(),

            // 4. Continue Learning Section
            _buildContinueLearning(),

            // 5. Quick Links (Daily Quiz & Past Papers)
            _buildQuickLinks(),

            // 6. Recent PDF List (Main Lessons ከ Firestore)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "Latest Study Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildFirestoreNotesList(),

            const SizedBox(height: 20), // පහළින් කුඩා ඉඩක්
          ],
        ),
      ),
    );
  }

  // --- 1 & 2. Profile Card & Countdown Timer (Stream-based for instant UI updates) ---
  Widget _buildHeaderSection(BuildContext context) {
    if (currentUser == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot>(
      // Real-time දත්ත ලබාගැනීමට snapshots() භාවිතා කර ඇත
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String studentName = "Loading...";
        String studentGrade = "...";
        DateTime examDate = DateTime(2026, 10, 16); // Default Exam Date එකක්

        if (snapshot.hasData && snapshot.data!.exists) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          studentName = userData['name'] ?? "Unknown Student";
          studentGrade = userData['grade'] ?? "N/A";

          if (userData['examDate'] != null) {
            examDate = (userData['examDate'] as Timestamp).toDate();
          }
        }

        // දින ගණනය කිරීමේ Logic එක
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime targetExamDate = DateTime(
          examDate.year,
          examDate.month,
          examDate.day,
        );
        int remainingDays = targetExamDate.difference(today).inDays;

        return Column(
          children: [
            // Profile Card Widget
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back,",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        studentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Grade: $studentGrade",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          backgroundColor: Colors.white24,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 6,
                        ),
                      ),
                      const Text(
                        "65%",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Countdown Timer Card Widget
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: remainingDays >= 0 ? Colors.amber[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: remainingDays >= 0
                        ? Colors.orange[800]
                        : Colors.red[800],
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "O/L Exam Countdown",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          remainingDays > 0
                              ? "Remaining: $remainingDays Days more!"
                              : remainingDays == 0
                              ? "Today is the Exam Day! 🎯"
                              : "Exam is Over!",
                          style: TextStyle(
                            color: remainingDays >= 0
                                ? Colors.orange[900]
                                : Colors.red[950],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_calendar,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () => _selectExamDate(context, examDate),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Date Picker එක සහ Firestore Update එක ---
  Future<void> _selectExamDate(
    BuildContext context,
    DateTime currentExamDate,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentExamDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null && currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'examDate': Timestamp.fromDate(pickedDate)});
    }
  }

  // --- 3. Subject Grid Widget ---
  Widget _buildSubjectGrid() {
    List<Map<String, dynamic>> subjects = [
      {'name': 'Maths', 'icon': Icons.calculate, 'color': Colors.red},
      {'name': 'ICT', 'icon': Icons.computer, 'color': Colors.orange},
      {'name': 'Science', 'icon': Icons.science, 'color': Colors.green},
      {'name': 'English', 'icon': Icons.translate, 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15, top: 20, bottom: 10),
          child: Text(
            "Subjects",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
          ),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: subjects[index]['color'].withOpacity(0.1),
                  child: Icon(
                    subjects[index]['icon'],
                    color: subjects[index]['color'],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subjects[index]['name'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // --- 4. Continue Learning Widget ---
  Widget _buildContinueLearning() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Continue Learning",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 35),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "HTML Lesson 02",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "ICT | Grade 10",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 5. Quick Links Widget ---
  Widget _buildQuickLinks() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickLinkCard(
            "Daily MCQ Quiz",
            Icons.quiz,
            Colors.blue,
            () {},
          ),
        ),
        Expanded(
          child: _buildQuickLinkCard(
            "Past Papers",
            Icons.history_edu,
            Colors.purple,
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinkCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. Firestore Notes List Widget ---
  Widget _buildFirestoreNotesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('notes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No notes available."),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var note = snapshot.data!.docs[index];

            String title = note.data().toString().contains('title')
                ? note['title']
                : 'Unknown Title';
            String subject = note.data().toString().contains('subject')
                ? note['subject']
                : 'Unknown';
            String grade = note.data().toString().contains('grade')
                ? note['grade']
                : 'Unknown';
            String pdfUrl = note.data().toString().contains('url')
                ? note['url']
                : '';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Subject: $subject | Grade: $grade",
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
                onTap: () async {
                  if (pdfUrl.isNotEmpty) {
                    final Uri url = Uri.parse(pdfUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Could not open the PDF file."),
                        ),
                      );
                    }
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
